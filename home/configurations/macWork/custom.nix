{
  pkgs,
  ...
}:
{
  custom = {
    dotfiles.enable = true;
    runtimes = {
      enable = true;
      java = [
        pkgs.jdk11
        pkgs.jdk8
      ];
    };

    programs = {
      aws-sso-cli.enable = true;
      flameshot.enable = true;
      rust.enable = true;
      scala = {
        enable = true;
        sbtOptions = [ "-Xmx8000M" ];
      };
      gpg.enable = true;
      python = {
        enable = true;
        extraPackages =
          pythonPkgs: with pythonPkgs; [
            requests
            pandas
          ];

        uv.enable = true;
      };
    };
  };
}
