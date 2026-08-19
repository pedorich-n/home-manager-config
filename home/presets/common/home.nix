{
  pkgs,
  lib,
  ...
}:
{
  home = {
    stateVersion = lib.mkDefault "26.05";

    packages = with pkgs; [
      curl # HTTP client
      dig # DNS lookup utility
      gdu # Fast disk usage analyser
      gnused # GNU Stream EDitor
      jq # Command-line JSON processor
      just # Handy tool to save and run project-specific commands.
      tree # Recursive directory listing
    ];

    sessionVariables = {
      PAGER = lib.mkDefault "less -R"; # Enable colors in less
      HOSTNAME = lib.mkDefault "$(hostname)";
    };

    shellAliases = {
      ll = "ls --all --classify --human-readable --color --group-directories-first -l";
    };

    shell = {
      enableBashIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
    };
  };

}
