{ python3Packages, nvd }:
let
  pyproject = with builtins; (fromTOML (readFile ./src/pyproject.toml)).project;
in
python3Packages.buildPythonPackage {
  pname = pyproject.name;
  inherit (pyproject) version;
  meta.description = pyproject.description ? "";
  format = "pyproject";

  src = ./src;

  propagatedBuildInputs = [ nvd python3Packages.rich ];
}
