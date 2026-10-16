{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Proxy CA certificates installed by the company software
  proxyCaGlob = "/usr/local/etc/openssl/certs/*_proxy_cacerts.pem";
  # Public CAs + proxy CAs, rebuilt on activation
  customCaBundle = "${config.xdg.dataHome}/certs/ca-bundle.pem";
in
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

    # Rebuild the CA bundle on every switch so proxy CA rotations get picked up
    activation.buildCaBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      proxyCas=(${proxyCaGlob})
      if [ -r "''${proxyCas[0]}" ]; then
        run mkdir -p "$(dirname ${customCaBundle})"
        run sh -c 'cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt "$@" > ${customCaBundle}.tmp \
          && mv ${customCaBundle}.tmp ${customCaBundle}' sh "''${proxyCas[@]}"
        noteEcho "Custom CA bundle updated: ${customCaBundle}"
      else
        warnEcho "No ${proxyCaGlob} found, keeping the existing CA bundle"
      fi
    '';

    sessionVariables = {
      # Make various programs use custom SSL certificates
      SSL_CERT_FILE = customCaBundle; # OpenSSL and most tools
      NIX_SSL_CERT_FILE = customCaBundle; # Nix
      NODE_EXTRA_CA_CERTS = customCaBundle; # Node.js, Bun
      REQUESTS_CA_BUNDLE = customCaBundle; # Python requests
      PIP_CERT = customCaBundle; # pip
      CARGO_HTTP_CAINFO = customCaBundle; # cargo
      AWS_CA_BUNDLE = customCaBundle; # AWS CLI, boto3
    };
  };
}
