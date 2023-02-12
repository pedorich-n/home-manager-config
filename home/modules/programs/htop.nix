{ pkgs, pyenv-flake, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.htop;
in
{
  ###### interface
  options = {
    custom.programs.htop = {
      enable = mkEnableOption "htop";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;

      settings = {
        fields = with config.lib.htop.fields; [
          PID
          USER
          PRIORITY
          NICE
          M_SIZE
          M_RESIDENT
          M_SHARE
          STATE
          PERCENT_CPU
          PERCENT_MEM
          TIME
          COMM
        ];
        tree_view = 1;

        highlight_base_name = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;

        hide_kernel_threads = 1;
        hide_userland_threads = 1;
        shadow_other_users = 1;

        find_comm_in_cmdline = 1;
        strip_exe_from_cmdline = 1;
        show_merged_command = 1;
        sort_direction = 1;
        cpu_count_from_one = 1;
      } // (with config.lib.htop; leftMeters [
        (bar "AllCPUs4")
        (bar "Memory")
        (bar "Swap")
      ]) // (with config.lib.htop; rightMeters [
        (text "DateTime")
        (text "Uptime")
        (text "Tasks")
        (text "LoadAverage")
      ]);
    };
  };
}
