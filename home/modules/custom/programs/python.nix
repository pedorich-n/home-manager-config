{ pkgs, lib, config, ... }:
let
  cfg = config.custom.programs.python;
in
{
  ###### interface
  options = {
    custom.programs.python = {
      enable = lib.mkEnableOption "Python";

      package = lib.mkPackageOption pkgs "python3" { };

      extraPackages = lib.mkOption {
        type = lib.types.functionTo (lib.types.listOf lib.types.package);
        default = _: [ ];
        defaultText = lib.literalExpression ''
          python3Packages: with python3Packages; [];
        '';
        example = lib.literalExpression ''
          python3Packages: with python3Packages; [
            requests
          ];
        '';
        description = "Extra Python packages to install";
      };

      poetry = {
        enable = lib.mkEnableOption "Poetry";

        package = lib.mkPackageOption pkgs "poetry" { };

        plugins = lib.mkOption {
          type = lib.types.functionTo (lib.types.listOf lib.types.package);
          default = _: [ ];
        };

        resultPackage = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          internal = true;
          default = cfg.poetry.package.withPlugins (ps: (cfg.poetry.plugins ps));
        };
      };

      resultEnv = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        internal = true;
        default = cfg.package.withPackages (ps: (cfg.extraPackages ps));
      };
    };
  };


  ###### implementation
  config = lib.mkIf cfg.enable {

    # Default config
    # TODO: move to a separate file?
    custom.programs.python = {
      extraPackages = python3Packages: with python3Packages; [
        mypy # static type checker
        pip # package manager
        setuptools # utilities
        virtualenv # virtual environment manager
        isort # import sorter
        ruff # linter & formatter
      ];

      poetry = lib.mkIf cfg.poetry.enable {
        plugins = poetryPlugins: with poetryPlugins; [
          poetry-plugin-up # Poetry plugin to simplify package updates
          poetry-plugin-export # Poetry plugin to export the dependencies to various formats
        ];
      };
    };

    home.packages = [
      cfg.resultEnv
    ] ++ lib.optional cfg.poetry.enable cfg.poetry.resultPackage;
  };
}
