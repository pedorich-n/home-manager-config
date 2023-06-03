{ cqlsh-source, python311Packages }:
with python311Packages;
buildPythonPackage {
  pname = "cqlsh";
  version = cqlsh-source.shortRev;
  format = "pyproject";

  src = cqlsh-source;

  nativeBuildInputs = [ setuptools wheel ];
  propagatedBuildInputs = [ cassandra-driver six ];

}
