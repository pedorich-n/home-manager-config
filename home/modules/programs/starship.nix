{ lib, ... }:
with lib;
{
  programs.starship = {
    settings = {
      format = concatStrings [
        "$shell"
        "$username"
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

      directory = {
        truncation_length = 5;
        disabled = false;
        truncation_symbol = ".../";
        truncate_to_repo = false;
      };

      line_break = {
        disabled = true;
      };

      git_commit = {
        disabled = false;
        only_detached = false;
        tag_disabled = false;
      };

      git_status = {
        stashed = "";
      };

      time = {
        disabled = false;
      };

      shell = {
        disabled = false;
        format = "[$indicator]($style)";
        bash_indicator = "bsh ";
        zsh_indicator = "";
      };

      status = {
        disabled = false;
      };
    };
  };
}
