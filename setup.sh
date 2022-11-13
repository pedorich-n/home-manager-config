#!/bin/bash

set -x

machine=$1

case $machine in
    "wsl-personal")
        echo "sh <(curl -L https://nixos.org/nix/install) --no-daemon"
    ;;
    "work")
        echo "sh <(curl -L https://nixos.org/nix/install) --daemon"
    ;;
    "none")
        echo "none"
    ;;
esac

# nix-env -f '<nixpkgs>' -iA nixUnstable

# nix_config_path="/home/$USER/.config/nix"
# mkdir -p $nix_config_path
# echo "experimental-features = nix-command flakes" >> "$nix_config_path/nix.conf"

# nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz home-manager
# nix-channel --update