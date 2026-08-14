{
  pkgs,
  lib,
  config,
  ...
}:
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

      uv = {
        enable = lib.mkEnableOption "uv";

        package = lib.mkPackageOption pkgs "uv" { };
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
      extraPackages =
        python3Packages: with python3Packages; [
          mypy # static type checker
          pip # package manager
          setuptools # utilities
          virtualenv # virtual environment manager
          isort # import sorter
          ruff # linter & formatter
        ];
    };

    home.packages = [
      cfg.resultEnv
    ]
    ++ lib.optional cfg.uv.enable cfg.uv.package;
  };
}
