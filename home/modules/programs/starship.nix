{ lib, ... }:
with lib;
{
  programs.starship = {
    settings = {
      format = concatStrings [
        "$shell"
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
