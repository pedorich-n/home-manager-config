{ pkgs, minimalMkShell }:
{
  "gnome-config-edit" = minimalMkShell {
    packages = with pkgs; [
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome-extension-manager
    ];
  };
}
