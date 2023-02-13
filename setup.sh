#!/bin/bash

set -e

CONFIG=$1
NIX_PATH=$(which nix)

# Yeah, arch has to be hardcoded, see: https://github.com/nix-community/home-manager/issues/3075
ARCH="x86_64-linux"

function install_nix() {
    local nix_path=$1
    local config=$2
    if [[ -z "$nix_path" ]]; then
        echo "Intalling nix"
        case $config in
            "wslPersonal")
                echo "sh <(curl -L https://nixos.org/nix/install) --no-daemon"
            ;;
            "linuxWork")
                echo "sh <(curl -L https://nixos.org/nix/install) --daemon"
            ;;
        esac
    else
        echo "Nix already installed, skipping..."
    fi
}

function build() {
    local arch=$1
    local config=$2
    echo "Building Home-Manager configuration..."
    nix build .#homeConfigurations.$arch.$config.activationPackage --extra-experimental-features nix-command --extra-experimental-features flakes
}

function activate() {
    echo "Activating Home-Manage..."
    ./result/activate
}

install_nix "$NIX_PATH" "$CONFIG" &&
build $ARCH "$CONFIG" && 
activate