{
  programs.opencode = {
    settings = {
      permissions = [
        {
          action = "external_directory";
          resource = "$HOME/Work/*";
          effect = "allow";
        }
        {
          action = "edit";
          resource = "$HOME/Work/*";
          effect = "allow";
        }
      ];
    };
  };
}
