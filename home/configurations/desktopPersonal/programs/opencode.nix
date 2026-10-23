{
  programs.opencode = {
    settings = {
      permissions = [
        {
          action = "external_directory";
          resource = "$HOME/Projects/*";
          effect = "allow";
        }
      ];
    };
  };
}
