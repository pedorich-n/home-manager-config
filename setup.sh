#!/bin/bash

set -e

MACHINE=$1
NIX_PATH=$(which nix)

if [[ -z "$NIX_PATH" ]]; then
    echo "Intalling nix"
    case $MACHINE in
        "wslPersonal")
            echo "sh <(curl -L https://nixos.org/nix/install) --no-daemon"
        ;;
        "linuxWork")
            echo "sh <(curl -L https://nixos.org/nix/install) --daemon"
        ;;
    esac
else
    echo "nix already installed, skipping..."
fi

LINE="experimental-features = nix-command flakes"
NIX_CONFIG_FILE="/home/$USER/.config/nix/nix.conf"

mkdir -p $(dirname $NIX_CONFIG_FILE)

grep -sq "$LINE" "$NIX_CONFIG_FILE" || echo "$LINE" >> "$NIX_CONFIG_FILE"

echo "Building configuration..."
# Yeah, x86_64-linux has to be hardcoded, see: https://github.com/nix-community/home-manager/issues/3075
nix build .#homeConfigurations.x86_64-linux.$MACHINE.activationPackage

echo "Activating..."
./result/activate