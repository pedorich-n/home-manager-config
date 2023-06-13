# Taken from: https://github.com/NixOS/nixpkgs/pull/201518
{ stdenv, lib, fetchurl, unzip }:
let
  platformSuffix = if stdenv.isDarwin then (if stdenv.isAarch64 then "macos-arm64" else "macos") else "linux";
  binPath = "bin/copilot-agent-${platformSuffix}";
in
stdenv.mkDerivation rec {
  # Plugin info at: https://plugins.jetbrains.com/api/plugins/17718/
  pname = "github-copilot-intellij-agent";
  version = "1.2.8.2631";

  src =
    # updateId from https://plugins.jetbrains.com/api/plugins/17718/updates
    # To get hash:
    # nix-prefetch-url " https://plugins.jetbrains.com/plugin/download?updateId=$ { updateId }" --print-path --unpack
    # nix --extra-experimental-features nix-command hash path /nix/store/....  from above
    let updateId = "341846";
    in fetchurl {
      name = "${pname}-${version}-plugin.zip";
      url = "https://plugins.jetbrains.com/plugin/download?updateId=${updateId}";
      hash = "sha256-0nnSMdx9Vb2WyNHreOJMP15K1+AII/kCEAOiFK5Mhik=";
    };

  nativeBuildInputs = [ unzip ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    unzip -p $src github-copilot-intellij/copilot-agent/${binPath} | install -m755 /dev/stdin $out/${binPath}
    runHook postInstall
  '';

  # https://discourse.nixos.org/t/unrelatable-error-when-working-with-patchelf/12043
  # https://github.com/NixOS/nixpkgs/blob/db0d8e10fc1dec84f1ccb111851a82645aa6a7d3/pkgs/development/web/now-cli/default.nix
  preFixup =
    let
      binaryLocation = "$out/${binPath}";
      libPath = lib.makeLibraryPath [ stdenv.cc.cc ];
    in
    ''
      orig_size=$(stat --printf=%s ${binaryLocation})
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ${binaryLocation}
      patchelf --set-rpath ${libPath} ${binaryLocation}
      chmod +x ${binaryLocation}
      new_size=$(stat --printf=%s ${binaryLocation})
      var_skip=20
      var_select=22
      shift_by=$(expr $new_size - $orig_size)
      function fix_offset {
        location=$(grep -obUam1 "$1" ${binaryLocation} | cut -d: -f1)
        location=$(expr $location + $var_skip)
        value=$(dd if=${binaryLocation} iflag=count_bytes,skip_bytes skip=$location \
                   bs=1 count=$var_select status=none)
        value=$(expr $shift_by + $value)
        echo -n $value | dd of=${binaryLocation} bs=1 seek=$location conv=notrunc
      }
      fix_offset PAYLOAD_POSITION
      fix_offset PRELUDE_POSITION
    '';

  dontStrip = true;

  meta = rec {
    description = "The GitHub copilot IntelliJ plugin's native component";
    longDescription = ''
      The GitHub copilot IntelliJ plugin's native component, patched for Nix(OS) compatibility.
      bin/copilot-agent must be symlinked into the plugin directory, replacing the existing binary.
      For example:
      ```shell
      ln -s /run/current-system/sw/bin/copilot-agent ~/.local/share/JetBrains/IntelliJIdea2022.2/github-copilot-intellij/copilot-agent/bin/copilot-agent-linux
      ```
    '';
    homepage = "https://plugins.jetbrains.com/plugin/17718-github-copilot";
    downloadPage = homepage;
    changelog = homepage;
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ hacker1024 ];
    mainProgram = "copilot-agent-${platformSuffix}";
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
