_: {
  perSystem = {
    treefmt.config.settings.global.excludes = [
      # Doesn't support regex, only glob
      "**/_sources/generated.nix"
      "**/_sources/generated.json"
    ];
  };
}
