{
  programs.opencode = {
    settings = {
      permissions = [
        {
          action = "external_directory";
          resource = "$HOME/Work/*";
          effect = "allow";
        }
      ];
    };
  };
}
