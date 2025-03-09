# Bootstrapping new installation

## Using existing HM configuration

1. Install nix, see https://nixos.org/download/
2. Run `nix run --extra-experimental-features "nix-command flakes" "git+ssh://git@github.com/pedorich-n/home-manager-config#bootstrap-<hm_configuration_name>"`
   1. This will clone the repository to `~/home-manager-config` and run the `home-manager switch` for a given `hm_configuration_name`
