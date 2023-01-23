args @ { ... }:
{
  home.username = args.username;
  home.homeDirectory = "/home/${args.username}";
  home.stateVersion = args.stateVersion;

  programs.home-manager.enable = true;
}
