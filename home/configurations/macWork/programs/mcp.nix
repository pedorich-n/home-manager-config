{
  programs.mcp = {
    servers = {
      confluence = {
        url = "https://mcp.atlassian.com/v1/mcp";
      };

      fetch = {
        env = {
          SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
        };
      };
    };
  };
}
