{ pkgs, ... }:
# See https://1password.community/discussion/comment/719630/#Comment_719630
pkgs.writeShellApplication {
  name = "op";
  text = ''
    mapfile -d "" op_env_vars < <(env -0 | grep -z ^OP_ | cut -z -d= -f1)
    WSLENV="''${WSLENV:-}:$(IFS=:; echo "''${op_env_vars[*]}")"
    export WSLENV
    exec op.exe "$@"  
  '';
}
