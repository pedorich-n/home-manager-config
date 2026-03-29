inputs: _: prev: {
  vimPlugins = prev.vimPlugins // {
    tomorrow-theme = prev.callPackage ../packages/vim-tomorrow-theme {
      inherit (inputs) tomorrow-theme-source;
    };
  };

  wsl-1password-cli = prev.callPackage ../packages/wsl-1password-cli { };

  hmd = prev.callPackage ../packages/hmd { };

  kde-themes = {
    otto = prev.callPackage ../packages/kde-themes/otto.nix { inherit (inputs) otto-theme; };
    otto-light = prev.callPackage ../packages/kde-themes/otto-light.nix { inherit (inputs) otto-light-theme; };
  };

  custom-wallpapers = prev.callPackage ../packages/wallpapers/default.nix { };

  zsh-tab-title = prev.callPackage ../packages/zsh-tab-title { };

  # For some reason aws-sso-cli can't build on my due to the checkPhase, so I have to ignore some tests
  aws-sso-cli = prev.aws-sso-cli.overrideAttrs {
    checkFlags =
      let
        skippedTests = [
          "TestAWSConsoleUrl"
          "TestAWSFederatedUrl"
          "TestServerWithSSL" # https://github.com/synfinatic/aws-sso-cli/issues/1030 -- remove when version >= 2.x
          "TestFileEdit"
          "TestUtilsSuite"
          "TestGenerateNewFile"
          "TestEnsureDirExists"
        ];
      in
      [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];
  };
}
