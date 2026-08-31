import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const cfgHome = process.env.XDG_CONFIG_HOME ?? join(homedir(), ".config");
const file = join(cfgHome, "opencode", "mcps.json");

export default async () => {
  let parsed;
  try {
    parsed = JSON.parse(readFileSync(file, "utf8"));
  } catch {
    return {};
  }
  const mcp = parsed.mcp ?? {};
  return {
    config: (cfg) => {
      // Plugin provides defaults; cfg.mcp (from opencode.json) wins per-server.
      cfg.mcp = { ...mcp, ...cfg.mcp };
    },
  };
};
