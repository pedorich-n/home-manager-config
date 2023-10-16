{ pkgs, lib, ... }:
# inspired by https://github.com/nix-community/nixGL/issues/44#issuecomment-1720381420
# and https://github.com/nix-community/nixGL/issues/44#issuecomment-1361524862
pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapped"
{
  buildInputs = [ pkgs.makeWrapper ];
} ''
  mkdir $out

  # copies directory structure
  for folder in $(cd ${pkg} && find -L -type d -links 2); do
    folder=$(echo $folder | cut -c 2-)
    mkdir -p "$out$folder"
  done;

  # symlinks all files
  for file in $(cd ${pkg} && find -L); do
    file=$(echo $file | cut -c 2-)
    if [[ -f ${pkg}$file ]]; then
      ln -s "${pkg}$file" "$out$file"
    fi
  done;

  # wraps all binaries
  for file in ${pkg}/bin/*; do
    # Can't use this, because wrapProgram checks that $file is executable. And it's not :(, it's a symlink
    # wrapProgram "$out/bin/$file" \
    #  --argv0 ${lib.getExe pkgs.nixgl.nixGLIntel}

    wrapped_file=$out/bin/$(basename $file)
    rm $wrapped_file
    echo "exec ${lib.getExe pkgs.nixgl.nixGLIntel} $file \"\$@\"" > $wrapped_file
    chmod +x $wrapped_file
  done;

  # wraps .desktop files if any
  for desktop in ${pkg}/share/applications/*.desktop; do
    wrapped_desktop=$out/share/applications/$(basename $desktop)
    rm $wrapped_desktop
    cp $desktop $wrapped_desktop

    # Assumes full path to the binary is used in the desktop files
    sed -i "s|${pkg}/bin|$out/bin|" $wrapped_desktop
  done;
''
