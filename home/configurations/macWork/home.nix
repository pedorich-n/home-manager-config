{
  config,
  pkgs,
  ...
}:
{
  home = {
    username = "mpedorich";
    homeDirectory = "/Users/${config.home.username}";

    packages = with pkgs; [
      awscli2 # AWS CLI
      nerd-fonts.fira-code # IDE & terminal font
      saml2aws # AWS SSO
      shfmt # Shell formatter
      opentofu
      tofu-ls
    ];

    shellAliases = {
      "zellij_pwd" = "zellij --session $(pwd | xargs basename)";
    };
  };
}
