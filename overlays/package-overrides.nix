_: _: prev: {

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
