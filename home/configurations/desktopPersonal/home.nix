{
  pkgs,
  ...
}:
{
  home = {
    username = "nikita";

    packages = with pkgs; [
      jquake
      opentofu
      tofu-ls
    ];
  };
}
