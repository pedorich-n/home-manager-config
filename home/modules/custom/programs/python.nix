{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.python;
in
{
  ###### interface
  options = {
    custom.programs.python = {
      enable = mkEnableOption "Python";

      package = mkOption {
        type = types.package;
        default = pkgs.python3;
        defaultText = literalExpression ''pkgs.python3'';
        description = "Python package to use";
      };

      extraPackages = mkOption {
        type = types.functionTo (types.listOf types.package);
        default = _: [ ];
        defaultText = literalExpression ''
          python3Packages: with python3Packages; [];
        '';
        example = literalExpression ''
          python3Packages: with python3Packages; [
            requests
          ];
        '';
        description = "Extra Python packages to install";
      };
    };
  };


  ###### implementation
  config =
    let
      pythonPackage = cfg.package.withPackages (ps: with ps; [
        black # code formatter
        isort # import sorter
        mypy # static type checker
        pip # package manager
        setuptools # utilities
        virtualenv # virtual environment manager
      ] ++ (cfg.extraPackages ps));

      poetryPackage = pkgs.poetry.withPlugins (ps: with ps; [
        poetry-plugin-up # Poetry plugin to simplify package updates
      ]);

    in
    mkIf cfg.enable {
      home.packages = [
        pythonPackage # python with packages
        poetryPackage # package manager with plugins
        pkgs.ruff # linter
      ];
    };
}
