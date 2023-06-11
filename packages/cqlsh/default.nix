{ cqlsh-source, python3Packages }:
with python3Packages;
buildPythonPackage {
  pname = "cqlsh";
  version = cqlsh-source.shortRev;
  format = "pyproject";

  src = cqlsh-source;

  nativeBuildInputs = [ setuptools wheel ];
  propagatedBuildInputs = [ cassandra-driver six ];
}
