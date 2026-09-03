{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    worktrunk # Git worktree manager for parallel AI agent workflows
  ];
}
