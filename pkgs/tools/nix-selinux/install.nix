{
  callPackage,
  writeShellApplication,
  gnugrep,
}:
let
  nix-selinux = callPackage ./build.nix { };
in
writeShellApplication {
  name = "install-nix-selinux";

  runtimeInputs = [
    nix-selinux
    gnugrep
  ];

  text = ''
    echo "Installing nix-selinux..."

    sudo semodule -i "${nix-selinux}/nix.pp"

    echo "Relabelling nix store..."
    sudo restorecon -R -v /nix

    echo "Done!"
  '';
}
