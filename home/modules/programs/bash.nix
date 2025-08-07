_: {
  programs.bash = {
    shellAliases = {
      # Some aliases from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
      gaa = "git add --all";
      gcam = "git commit --all --message";
      gd = "git diff";
      gl = "git pull";
      gst = "git status";
      grbc = "git rebase --continue";
      gp = "git push";
      gpf = "git push --force-with-lease";
    };
  };
}
