{
  writeShellApplication,
  ripgrep,
  gum,
  nvd,
  ...
}:
writeShellApplication {
  name = "hmd";
  runtimeInputs = [
    gum
    ripgrep
    nvd
  ];

  text = ''
    declare -r globalProfilesDir="''${NIX_STATE_DIR:-/nix/var/nix}/profiles/per-user/$USER"
    declare -r userNixProfilesDir="''${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles"

    if [[ -d "''${userNixProfilesDir}" ]]; then
      declare -r HM_PROFILES_DIR="$userNixProfilesDir"
    elif  [[ -d "''${globalProfilesDir}" ]]; then
      declare -r HM_PROFILES_DIR="$globalProfilesDir"
    else
      echo "Can't find HomeManager profiles dir!"
      exit 1
    fi

    mapfile -t generations < <(find "$HM_PROFILES_DIR" | rg "home-manager-(\d+)-link" --only-matching --replace '$1' | sort --numeric-sort --reverse)

    if [ "''${#generations[@]}" -lt 2 ]; then
      echo "Not enough Home Manager generations to compare"
      exit 0
    fi

    make_profile_path() {
      printf "%s/home-manager-%d-link\n" "$HM_PROFILES_DIR" "$1"
    }

    if [[ "''${1:-}" == "--auto" ]]; then
      # shellcheck disable=SC2086
      selections=("$(make_profile_path ''${generations[0]})" "$(make_profile_path ''${generations[1]})")
    else
      declare -a choices=()
      for generation in "''${generations[@]}"; do
        # shellcheck disable=SC2086
        path="$(make_profile_path $generation)"
        createdAtEpoch=$(stat -c "%Z" "$path")
        createdAtHuman=$(date "+%F %T" -d "@$createdAtEpoch")
        choice=$(printf "%d: %s|%s" "$generation" "$createdAtHuman" "$path")
        choices+=("$choice")
      done

      for prompt in "first" "second"; do
        selected=$(printf "%s\n" "''${choices[@]}" | gum choose --header="Select $prompt generation" --label-delimiter="|" --height=10 --limit=1)
        selections+=("$selected")
      done
    fi

    nvd diff "''${selections[0]}" "''${selections[1]}"
  '';
}
