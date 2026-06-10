{
  programs.mise.globalConfig = {
    settings = {
      # Enables support for .tool-versions, .terraform-version, .nvmrc, etc. files
      idiomatic_version_file_enable_tools = [
        "terraform"
        "node"
      ];
    };
  };
}
