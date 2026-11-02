{
  _module.args.opencodeLib = {
    mkExternalDirectoryPermissions =
      {
        path,
        extDirEffect ? "allow",
        action ? "read",
        actionEffect ? "allow",
      }:
      [
        {
          action = "external_directory";
          resource = path;
          effect = extDirEffect;
        }
        {
          inherit action;
          resource = path;
          effect = actionEffect;
        }
      ];

    mkShellPermission =
      {
        command,
        effect ? "ask",
      }:
      [
        {
          action = "shell";
          resource = command;
          inherit effect;
        }
      ];
  };
}
