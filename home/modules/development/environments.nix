{ self, pkgs, lib, customLib, config, ... }:
with lib;
let
  cfg = config.custom.development.environments;

  # java-17 = pkgs-unstable.temurin-bin-17.overrideAttrs (_: { meta.priority = -10; }); # TODO: try this out
  # java-17-default = pkgs-unstable.jdk17;
  java-17-default = pkgs.jdk;

  withIdeOption = {
    withIde = (mkEnableOption "With IDE") // { default = true; };
  };

  jdkSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "JDK";
      package = mkOption {
        type = types.package;
        default = java-17-default;
        description = "JDK to use";
      };
    };
  };

  scalaSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Scala";
      version = mkOption {
        type = types.enum [ "2.10" "2.11" "2.12" "2.13" ];
        default = "2.13";
        description = "Major Scala 2.X version to install";
      };
    } // withIdeOption;
  };

  rustSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Rust";
      version = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Rust version to install using rustup";
      };
      rustupProfile = mkOption {
        type = types.str;
        default = "default";
        description = "Rustup profile to use";
      };
    };
  };

  pythonSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Python";
    } // withIdeOption;
  };

  aliasSubmoduleFor = name: types.submodule {
    options = {
      enable = mkEnableOption "Alias for ${name}";
      name = mkOption {
        type = types.str;
        default = "${name}";
        description = "Folder name for the alias";
      };
    };
  };

  aliasesSubmodule = types.submodule {
    options = {
      root = mkOption {
        type = types.str;
        default = ".sdks";
        description = "Root folder for aliases (under $HOME)";
      };

      scala = mkOption {
        type = aliasSubmoduleFor "scala";
        default = { };
      };
      jdk = mkOption {
        type = aliasSubmoduleFor "jdk";
        default = { };
      };
    };
  };

  buildAlaisFor = name: source: mkIf (cfg.${name}.enable && cfg.aliases.${name}.enable) { "${cfg.aliases.root}/${cfg.aliases.${name}.name}".source = source; };
in
{
  ###### interface
  options = {
    custom.development.environments = {
      enable = mkEnableOption "Development Environments";

      jdk = mkOption {
        type = jdkSubmodule;
        default = { };
      };

      scala = mkOption {
        type = scalaSubmodule;
        default = { };
      };

      rust = mkOption {
        type = rustSubmodule;
        default = { };
      };

      # Pyenv actually builds python from sources, that requires some additional dependencies available in PATH
      # so I won't implement the version selection here, like for Rust
      python = mkOption {
        type = pythonSubmodule;
        default = { };
      };

      aliases = mkOption {
        type = aliasesSubmodule;
        default = { };
      };
    };
  };


  ###### implementation
  config =
    let
      jdkEnabled = cfg.jdk.enable;
      scalaEnabled = cfg.scala.enable;
      pythonEnabled = cfg.python.enable;
      rustEnabled = cfg.rust.enable;
      enabled = cfg.enable || jdkEnabled || scalaEnabled || pythonEnabled || rustEnabled;

      jdkPkgs = lists.optional jdkEnabled cfg.jdk.package;

      scala = pkgs.scala.override { majorVersion = cfg.scala.version; jre = cfg.jdk.package; };

      scalaPkgs = lists.optionals scalaEnabled
        (with pkgs; [
          scala
          (coursier.override { jre = cfg.jdk.package; })
          (sbt.override { jre = cfg.jdk.package; })
        ]) ++ lists.optional (scalaEnabled && cfg.scala.withIde) (pkgs.jetbrains.idea-community.override { jdk = cfg.jdk.package; });

      pythonPkgs = lists.optionals (pythonEnabled && cfg.python.withIde) (with pkgs; [
        (jetbrains.pycharm-community.override { jdk = cfg.jdk.package; })
      ]);

      rustPkgs = lists.optionals rustEnabled (with pkgs; [
        rustup
      ]);

      isInstallRust = rustEnabled && (customLib.nonEmpty cfg.rust.version);
      installRustBlock = ''
        $DRY_RUN_CMD rustup ''${VERBOSE_ARG:---quiet} set profile ${cfg.rust.rustupProfile}
        $DRY_RUN_CMD rustup ''${VERBOSE_ARG:---quiet} ${cfg.rust.rustupProfile} ${cfg.rust.version}
      '';

    in
    mkIf enabled {
      custom.programs = {
        pyenv.enable = mkIf pythonEnabled true;
        zsh.snap.fpaths = lists.optional rustEnabled { name = "_rustup"; command = "rustup completions zsh"; };
      };

      home = {
        packages = jdkPkgs ++ scalaPkgs ++ pythonPkgs ++ rustPkgs;

        file = lib.mkMerge [
          (buildAlaisFor "scala" scala)
          (buildAlaisFor "jdk" cfg.jdk.package)
        ];

        extraActivationPath = lists.optionals isInstallRust rustPkgs;
        activation = with lib.hm; {
          installRustupToolchain = mkIf isInstallRust (dag.entryAfter [ "linkGeneration" ] installRustBlock);
        };
      };

      xdg.configFile = {
        "ideavim/ideavimrc" = mkIf ((scalaEnabled && cfg.scala.withIde) || (pythonEnabled && cfg.python.withIde)) { text = builtins.readFile "${self}/dotfiles/.ideavimrc"; };
      };
    };
}
