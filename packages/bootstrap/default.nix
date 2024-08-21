{ pkgs, configName ? "", ... }:
pkgs.writeShellApplication {
  name = "hm-bootrstrap";
  runtimeInputs = with pkgs; [
    gitMinimal
    home-manager
  ];

  text = ''
    REPO_URL="git@github.com:pedorich-n/config.nix.git"
    FLAKE_PATH="$HOME/.config.nix"

    config_name=''${1:-${configName}}
  
    if [ -d "$FLAKE_PATH" ]; then
        echo "Target folder already exists! Aborting"
        exit 1
    else
        echo "Target folder does not exist. Cloning the repository..."
        
        if [ "$(git clone "$REPO_URL" "$FLAKE_PATH")" ]; then
            echo "Repository cloned successfully into $FLAKE_PATH."
        else
            echo "Failed to clone the repository."
            exit 1
        fi
    fi

    echo "Running home-manager switch..."
    export HOME_MANAGER_BACKUP_EXT="backup"
    home-manager switch --flake "$FLAKE_PATH#$config_name"
  '';
}
