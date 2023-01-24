#!/bin/bash

# set -x

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

grep -q "$LINE" "$NIX_CONFIG_FILE" || echo "$LINE" >> "$NIX_CONFIG_FILE"

echo "Building configuration..."
nix build .#homeConfigurations.$MACHINE.activationPackage

echo "Activating..."
./result/activate