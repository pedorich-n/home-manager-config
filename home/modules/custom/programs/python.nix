{
  custom.programs.python = {
    extraPackages =
      python3Packages: with python3Packages; [
        # keep-sorted start
        isort # import sorter
        mypy # static type checker
        pip # package manager
        requests # Library for making http requests
        ruff # linter & formatter
        setuptools # utilities
        virtualenv # virtual environment manager
        # keep-sorted end
      ];
  };
}
