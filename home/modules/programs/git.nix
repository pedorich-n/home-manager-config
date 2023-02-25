_:
{
  programs.git = {
    userName = "Nikita Pedorich";
    userEmail = "pedorich.n@gmail.com";

    extraConfig = {
      pull.rebase = true;
      push.default = "simple";
    };
  };
}
