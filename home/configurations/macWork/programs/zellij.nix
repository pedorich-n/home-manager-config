{
  programs.zellij = {
    enable = true;

    layouts = {
      sbt = ''
        layout {
          tab_template name="with-status-bar" {
            children
            pane size=1 borderless=true {
                plugin location="zellij:status-bar"
            }
          }

          pane stacked=true {
            pane command="sbt" expanded=true focus=true
            pane command="opencode"
            pane name="Shell"
          }
          pane size=1 borderless=true {
              plugin location="zellij:status-bar"
          }
        }
      '';
    };
  };
}
