{ pkgs, ... }:
{
  "gnome-config-edit" = pkgs.mkShellNoCC {
    packages = with pkgs; [
      dconf2nix
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome-extension-manager
    ];
  };
}
