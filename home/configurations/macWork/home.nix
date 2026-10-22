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

  sslEnvVariables = [
    "SSL_CERT_FILE" # OpenSSL and most tools
    "NIX_SSL_CERT_FILE" # Nix
    "NODE_EXTRA_CA_CERTS" # Node.js, Bun
    "REQUESTS_CA_BUNDLE" # Python requests
    "PIP_CERT" # pip
    "CARGO_HTTP_CAINFO" # cargo
    "AWS_CA_BUNDLE" # AWS CLI, boto3
  ];
in
{
  home = {
    username = "mpedorich";

    packages = with pkgs; [
      awscli2
      shfmt
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

    sessionVariables = lib.genAttrs sslEnvVariables (_name: customCaBundle);

    sessionPath = [
      "$HOME/.rd/bin"
    ];
  };

  custom.programs.java.toolOptions = [ "-Djavax.net.ssl.trustStore=${javaTrustStore}" ];
}
