{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Nikita Pedorich";
    signing = {
      signByDefault = false;
    };
    extraConfig = {
      pull.rebase = true;
      push.default = "simple";
    };
  };
}
