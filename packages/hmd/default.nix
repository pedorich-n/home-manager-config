{ writeShellApplication
, fzf
, ripgrep
, nvd
, ...
}:
writeShellApplication {
  name = "hmd";
  runtimeInputs = [
    fzf
    ripgrep
    nvd
  ];

  text = ''
    declare -r globalProfilesDir="''${NIX_STATE_DIR:-/nix/var/nix}/profiles/per-user/$USER"
    declare -r userNixProfilesDir="''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles"

    if [[ -d "''${userNixProfilesDir}" ]]; then
      declare -r HM_PROFILES_DIR="''${userNixProfilesDir}"
    elif  [[ -d "''${globalProfilesDir}" ]]; then
      declare -r HM_PROFILES_DIR="''${globalProfilesDir}"
    else
      echo "Can't find HomeManager profiles dir!"
      exit 1
    fi

    mapfile -t generations < <(find "''${HM_PROFILES_DIR}" | rg "home-manager-(\d+)-link" --only-matching --replace '$1' | sort --numeric-sort --reverse)

    for prompt in "first" "second"; do
        selections+=("$(printf "%s\n" "''${generations[@]}" | fzf --header="Select $prompt generation" --border --height 10 --cycle --no-multi)")
    done

    make_profile_path() {
      printf "%s/home-manager-%d-link\n" "''${HM_PROFILES_DIR}" "$1"
    }

    # shellcheck disable=SC2086
    nvd diff "$(make_profile_path ''${selections[0]})" "$(make_profile_path ''${selections[1]})"
  '';
}
