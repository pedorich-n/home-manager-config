{ pkgs, minimalMkShell }:
{
  "gnome-config-edit" = minimalMkShell {
    packages = with pkgs; [
      dconf2nix
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome-extension-manager
    ];
  };
}
