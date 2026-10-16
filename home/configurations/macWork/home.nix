{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Root CA installed by the company software
  proxyRootCa = "/usr/local/etc/openssl/certs/*_root_ca.pem";
  # Public CAs + company Root CA, rebuilt on activation
  customCaBundle = "${config.xdg.dataHome}/certs/ca-bundle.pem";
  # JDK public CAs + company Root CA, rebuilt on activation
  javaTrustStore = "${config.xdg.dataHome}/certs/java-truststore.jks";
  jdk = config.programs.java.package;
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

    activation = {
      # Rebuild the CA bundle on every switch so proxy CA rotations get picked up
      buildCaBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ -r ${proxyRootCa} ]; then
          run mkdir -p "$(dirname ${customCaBundle})"
          run sh -c 'cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt ${proxyRootCa} > ${customCaBundle}.tmp \
            && mv ${customCaBundle}.tmp ${customCaBundle}'
          noteEcho "Custom CA bundle updated: ${customCaBundle}"
        else
          warnEcho "No ${proxyRootCa} found, keeping the existing CA bundle"
        fi
      '';

      # Java needs its own certificates truststore
      buildJavaTrustStore = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ -r ${proxyRootCa} ]; then
          run install -D -m 644 ${jdk.home}/lib/security/cacerts ${javaTrustStore}
          run ${lib.getExe' jdk "keytool"} -importcert -noprompt -alias proxy-root-ca -storepass changeit \
            -file ${proxyRootCa} -keystore ${javaTrustStore}
          noteEcho "Custom Java truststore updated: ${javaTrustStore}"
        else
          warnEcho "No ${proxyRootCa} found, keeping the existing Java truststore"
        fi
      '';
    };

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

  custom.programs.java.toolOptions = [ "-Djavax.net.ssl.trustStore=${javaTrustStore}" ];
}
