{ config, pkgs, lib, ... }:
{
  programs.htop = {
    package = pkgs.htop;

    # Defined in https://github.com/nix-community/home-manager/blob/c2cd2a52e02f1dfa1c88f95abeb89298d46023be/modules/programs/htop.nix#L167-L169
    settings = lib.mkDefault (with config.lib.htop; {
      fields = with fields; [
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
    } // (leftMeters [
      (bar "AllCPUs4")
      (bar "Memory")
      (bar "Swap")
    ]) // (rightMeters [
      (text "DateTime")
      (text "Uptime")
      (text "Tasks")
      (text "LoadAverage")
    ]));
  };
}
