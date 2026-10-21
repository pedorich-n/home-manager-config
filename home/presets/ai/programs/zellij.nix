{
  programs.zellij.layouts.ai = ''
    layout {
      pane stacked=true {
        pane name="opencode" command="opencode" focus=true expanded=true
        pane name="hunk watch" command="hunk" {
          args "diff" "--watch"
        }
        pane name="shell"
      }
      pane size=1 borderless=true {
        plugin location="zellij:status-bar"
      }
    }
  '';
}
