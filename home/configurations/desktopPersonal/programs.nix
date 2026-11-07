{
  pkgs,
  ...
}:
{
  programs = {
    gh.enable = true;
    java = {
      enable = true;
      package = pkgs.jre;
    };
    keychain.enable = false;
    mise.enable = true;
    obsidian.enable = true;
    plasma.enable = true;
    rclone.enable = true;
  };
}
