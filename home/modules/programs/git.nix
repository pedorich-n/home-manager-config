{ custom-params, ... }:

{
  programs.git = {
    enable = true;
    userName = "Nikita Pedorich";
    userEmail = custom-params.git.email;
    signing = {
      key = custom-params.git.signing_key;
      signByDefault = false;
    };
    extraConfig = {
      pull.rebase = true;
      push.default = "simple";
    };
  };
}
