{
  programs.zellij.layouts.ai = ''
    layout {
      pane stacked=true {
        pane name="Opencode" command="opencode" focus=true expanded=true
        pane name="shell"
      }
      pane size=1 borderless=true {
        plugin location="zellij:status-bar"
      }
    }
  '';
}
