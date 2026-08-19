{
  pkgs,
  ...
}:
{
  home = {
    username = "mpedorich";

    packages = with pkgs; [
      awscli2 # AWS CLI
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
