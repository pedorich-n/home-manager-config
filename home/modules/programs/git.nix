{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Nikita Pedorich";
    extraConfig = {
      pull.rebase = true;
      push.default = "simple";
    };
  };
}
