{
  pkgs,
  ...
}:
{
  home = {
    username = "mykytapedorich";

    shellAliases = {
      "zellij_pwd" = "zellij --session $(pwd | xargs basename)";
    };

    packages = with pkgs; [
      awscli2 # AWS CLI
      caffeine-ng # Disable screensaver
      docker-compose # Docker
      nerd-fonts.fira-code # IDE & terminal font
      obsidian # Note-taking
      postman # Client for RESTful APIs
      saml2aws # AWS SSO
      shfmt # Shell formatter
      xclip # CLI Clipboard manager
      opentofu
      tofu-ls
    ];
  };
}
