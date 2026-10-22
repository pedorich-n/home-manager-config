{
  programs.tealdeer = {
    settings = {
      search = {
        languages = [ "en" ];
      };
      updates = {
        tls_backend = "rustls-with-native-roots";
      };
    };
  };
}
