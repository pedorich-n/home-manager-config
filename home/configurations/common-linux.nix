{ pkgs, pkgs-unstable, config, ... }:
let
  cfg = config.home;

  nixPkg = pkgs-unstable.nix;
  commonApps = with pkgs; [
    bat
    curl
    # This derivation installs a Variable font (multiple fonts in a single file). Idea doesn't support these :(
    # https://youtrack.jetbrains.com/issue/JBR-3674/Variable-fonts-support
    # fira-code
    # fira-code-symbols
    gdu
    jq
    keychain
    nixpkgs-fmt
    ripgrep
    rnix-lsp
    tmux
  ] ++ [ nixPkg ];

in
{
  home = {
    stateVersion = "22.11";

    homeDirectory = "/home/${cfg.username}";

    packages = commonApps;

    shellAliases = { global-nix = "/nix/var/nix/profiles/default/bin/nix"; };
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;

  nix = {
    package = nixPkg;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      log-lines = 50;
    };
  };
}
