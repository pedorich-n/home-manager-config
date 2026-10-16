{
  runCommand,
  vscode,
}:
runCommand "vscode-stub"
  {
    inherit (vscode) pname version;
    meta.mainProgram = "code";
  }
  ''
    mkdir -p $out/bin
    ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" $out/bin/code
  ''
