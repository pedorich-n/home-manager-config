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

    sessionVariables = {
      # Make various programs use custom SSL certificates
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    };
  };
}
