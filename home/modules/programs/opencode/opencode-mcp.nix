{
  lib,
  pkgs,
  config,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };

  # Copied from https://github.com/nix-community/home-manager/blob/99c9ec/modules/programs/opencode.nix#L24-L58
  toOpencodeShape =
    s:
    let
      isRemote = s ? url && s.url != null;
      renderedEnv = lib.hm.mcp.renderEnv (p: "{file:${p}}") (s.env or { });
    in
    lib.optionalAttrs (s.enabled or null != null) { inherit (s) enabled; }
    // {
      type = if isRemote then "remote" else "local";
    }
    // (
      if isRemote then
        { inherit (s) url; } // lib.optionalAttrs (s.headers or { } != { }) { inherit (s) headers; }
      else
        {
          command = [ s.command ] ++ (s.args or [ ]);
        }
        // lib.optionalAttrs (renderedEnv != { }) { environment = renderedEnv; }
    );

  transformedMcpServers =
    if config.programs.mcp.enable && config.programs.mcp.servers != { } then
      lib.mapAttrs (
        _: server:
        lib.hm.mcp.transformMcpServer {
          inherit server;
          extraTransforms = [ toOpencodeShape ];
          exclude = [
            "args"
            "env"
          ];
        }
      ) config.programs.mcp.servers
    else
      { };
in
{
  xdg.configFile."opencode/mcps.json" = lib.mkIf (config.programs.opencode.enable && transformedMcpServers != { }) {
    source = jsonFormat.generate "opencode-mcps.json" {
      mcp = transformedMcpServers;
    };
  };
}
