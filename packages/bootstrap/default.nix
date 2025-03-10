{ pkgs, lib, configName ? "", ... }:
pkgs.writeShellApplication {
  name = "hm-bootrstrap${lib.optionalString (configName != "") "-${configName}"}";
  runtimeInputs = with pkgs; [
    gitMinimal
    home-manager
  ];

  text = ''
    REPO_URL="git@github.com:pedorich-n/home-manager-config.git"
    FLAKE_PATH="$HOME/home-manager-config"

    config_name=''${1:-${configName}}

    switch() {
      echo "Running home-manager switch..."
      export HOME_MANAGER_BACKUP_EXT="backup"
      export NIXPKGS_ALLOW_UNFREE=1
      home-manager switch --extra-experimental-features "nix-command flakes" --flake "$FLAKE_PATH#$config_name" --impure
    }

    if [ -d "$FLAKE_PATH" ]; then
        echo "Target folder already exists!"
        switch
    else
        echo "Target folder does not exist. Cloning the repository..."

        if [ "$(git clone "$REPO_URL" "$FLAKE_PATH")" ]; then
            echo "Repository cloned successfully into $FLAKE_PATH."
            switch
        else
            echo "Failed to clone the repository."
        fi
    fi
  '';
}
