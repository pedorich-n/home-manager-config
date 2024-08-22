{ pkgs, ... }:
{
  "gnome-config-edit" = pkgs.mkShellNoCC {
    packages = with pkgs; [
      dconf2nix
      dconf-editor
      gnome-tweaks
      gnome-extension-manager
    ];
  };
}
