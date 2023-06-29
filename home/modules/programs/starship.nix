{ lib, ... }:
with lib;
{
  programs.starship = {
    settings = {
      format = concatStrings [
        "$shell"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$aws"
        "$python"
        "$character"
      ];

      right_format = concatStrings [
        "$time"
        "$cmd_duration"
        "$status"
      ];

      add_newline = false;

      aws = {
        disabled = false;
        format = "on [$symbol($profile )(\\[$duration\\] )]($style)";
        profile_aliases = {
          "aws-core-staging-dev" = "staging";
          "aws-core-production-dev" = "production";
        };
        symbol = " ";
      };

      directory = {
        disabled = false;
        truncation_length = 3;
        truncation_symbol = "…/";
        truncate_to_repo = false;
      };

      git_commit = {
        disabled = false;
        only_detached = true;
        tag_disabled = true;
      };

      git_status = {
        disabled = false;
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

      python = {
        disabled = false;
        symbol = " ";
      };
    };
  };
}
