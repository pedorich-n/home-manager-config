{
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
}
