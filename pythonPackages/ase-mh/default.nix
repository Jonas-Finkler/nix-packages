{
  buildPythonPackage,
  fetchFromGitLab,
  numpy,
  ase,
  scipy,
  scikit-learn,
  networkx,
  mpi4py,
  sqnm,
  dataclasses-json,
  numba,
  spglib
}: buildPythonPackage {
  pname = "ase-mh";
  version = "1.0.1";
  src = fetchFromGitLab {
    owner = "goedeckergroup";
    repo = "ase_mh";
    rev = "05958e3ac109861a8c29c7edc2d7b4cb3dcd9658";
    sha256 = "sha256-sPkJVontIgizzAzjNUKJ/zan9uAZsXytz1Frd4c8d2g=";
    # fetchSubmodules = true;
    # deepClone = true;
  };
  format = "pyproject";
  
  buildInputs = [
  ];
  
  propagatedBuildInputs = [
    numpy
    ase
    scipy
    scikit-learn
    networkx
    mpi4py
    sqnm
    dataclasses-json
    numba
    spglib
  ];
  
  # doCheck = false;
}
  
