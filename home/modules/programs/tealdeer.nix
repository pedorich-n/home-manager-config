{ lib, ... }: {
  programs.tealdeer = {
    settings = lib.mkDefault {
      updates = {
        auto_update = true;
        auto_update_interval_hours = 168; # 1 week
      };

      display = {
        use_pager = false;
        compact = true;
      };
    };
  };
}
