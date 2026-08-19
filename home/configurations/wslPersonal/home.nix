{
  pkgs,
  ...
}:
{
  home = {
    username = "pedorich_n";

    packages = with pkgs; [
      wslu
      wsl-1password-cli
      opentofu
      tofu-ls
    ];
  };
}
