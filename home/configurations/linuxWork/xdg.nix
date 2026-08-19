{
  # Fixes the issue with Gnome's Nautilus not opening JSON files
  # See: https://gitlab.gnome.org/GNOME/nautilus/-/issues/3273#note_2217618
  # See: https://github.com/nix-community/home-manager/issues/4955#issuecomment-2041447196
  xdg.mime.enable = false;
}
