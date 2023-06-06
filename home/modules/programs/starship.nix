{ lib, ... }:
with lib;
{
  programs.starship = {
    settings = {
      format = concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$character"
      ];

      right_format = concatStrings [
        "$time"
        "$cmd_duration"
        "$status"
      ];

      add_newline = false;

      line_break = {
        disabled = true;
      };

      git_status = {
        modified = "⚡";
        staged = "";
        stashed = "";
      };

      time = {
        disabled = false;
      };

      status = {
        disabled = false;
      };
    };
  };
}
