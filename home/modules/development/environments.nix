{ self, pkgs, lib, customLib, config, ... }:
with lib;
let
  cfg = config.custom.development.environments;

  # java-17-default = pkgs.temurin-bin-17; # TODO: try this out
  java-17-default = pkgs.jdk17;

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
        type = types.enum [ "minimal" "default" ];
        default = "default";
        description = "Rustup profile to use";
      };
    };
  };

  pythonSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Python";
    };
  };

  aliasesSubmodule = types.submodule {
    options = {
      root = mkOption {
        type = types.str;
        default = ".sdks";
        description = "Root folder for aliases (under $HOME)";
      };

      additionalPackages = mkOption {
        type = with types; attrsOf path;
        default = { };
        description = "Arbitrary aliases";
      };
    };
  };

  buildAliasAttrFor = path: source: (lib.attrsets.nameValuePair "${cfg.aliases.root}/${path}" { inherit source; });
  buildAliasForCfg = name: path: source: lib.attrsets.optionalAttrs cfg.${name}.enable (buildAliasAttrFor path source);
  buildAliasesForPackages = lib.attrsets.mapAttrsToList buildAliasAttrFor;

  # isMetalsExtensionEnabled =
  #   let
  #     isMetals = str: customLib.nonEmpty (builtins.match ".*(metals).*" str);
  #     extensionNames = pkgs.lib.traceValSeq (builtins.map (ext: ext.name) config.programs.vscode.extensions);
  #   in
  #   builtins.any isMetals extensionNames;
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
      jdkAlias = buildAliasForCfg "jdk" "java-17" cfg.jdk.package;

      scala = pkgs.scala.override { majorVersion = cfg.scala.version; jre = cfg.jdk.package; };

      scalaPkgs = lists.optionals scalaEnabled
        (with pkgs; [
          scala
          (coursier.override { jre = cfg.jdk.package; })
          (bloop.override { jre = cfg.jdk.package; })
          (sbt.override { jre = cfg.jdk.package; })
          (ammonite.override { jre = cfg.jdk.package; })
        ]) ++ lists.optional (scalaEnabled && cfg.scala.withIde) pkgs.jetbrains.idea-community;

      scalaAlias = buildAliasForCfg "scala" "scala-${cfg.scala.version}" scala;

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

      # programs.vscode.userSettings = mkIf (config.programs.vscode.enable && isMetalsExtensionEnabled && isAliasEnabled "jdk") { "metals.javaHome" = "${config.home.homeDirectory}/" + buildAliasPathFor "jdk"; };

      home = {
        packages = jdkPkgs ++ scalaPkgs ++ rustPkgs;

        file = builtins.listToAttrs ([ jdkAlias scalaAlias ] ++ (buildAliasesForPackages cfg.aliases.additionalPackages));

        extraActivationPath = lists.optionals isInstallRust rustPkgs;
        activation = with lib.hm; {
          installRustupToolchain = mkIf isInstallRust (dag.entryAfter [ "linkGeneration" ] installRustBlock);
        };
      };

      xdg.configFile = {
        "ideavim/ideavimrc" = mkIf (scalaEnabled && cfg.scala.withIde) { text = builtins.readFile "${self}/dotfiles/.ideavimrc"; };
      };
    };
}
