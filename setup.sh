#!/bin/bash

set -e

CONFIG=$1
NIX_PATH=$(which nix || echo '')

function install_nix() {
	local nix_path=$1
	local config=$2
	if [[ -z $nix_path ]]; then
		echo "Intalling nix"
		case $config in
		"wslPersonal")
			sh <(curl -L https://nixos.org/nix/install) --no-daemon
			;;
		"linuxWork")
			sh <(curl -L https://nixos.org/nix/install) --daemon
			;;
		esac
	else
		echo "Nix already installed, skipping..."
	fi
}

function build() {
	local config=$1
	echo "Building Home-Manager configuration..."
	nix build .#homeConfigurations.$config.activationPackage --extra-experimental-features nix-command --extra-experimental-features flakes
}

function activate() {
	echo "Activating Home-Manager..."
	set HOME_MANAGER_BACKUP_EXT="backup"
	./result/activate
	unset HOME_MANAGER_BACKUP_EXT
}

install_nix "$NIX_PATH" "$CONFIG" &&
	build "$CONFIG" &&
	activate
