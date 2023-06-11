{ python3Packages, nvd }:
with python3Packages;
buildPythonPackage {
  pname = "hmd";
  version = "0.1";
  format = "pyproject";

  src = ./src;

  nativeBuildInputs = [ setuptools wheel ];
  propagatedBuildInputs = [ nvd rich ];
}
