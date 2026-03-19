{
  stdenv,
  libselinux,
  semodule-utils,
  checkpolicy,
  ...
}:
# Copied from https://github.com/nix-community/nix-installers/blob/3ed29c693f06e5/default.nix#L36-L58
stdenv.mkDerivation {
  name = "nix-selinux";
  src = ./source;

  nativeBuildInputs = [
    libselinux
    semodule-utils
    checkpolicy
  ];

  buildPhase = ''
    runHook preBuild

    checkmodule -M -m -o nix.mod nix.te
    semodule_package -o nix.pp -m nix.mod -f nix.fc

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir "$out"
    cp nix.pp "$out"/

    runHook postInstall
  '';
}
