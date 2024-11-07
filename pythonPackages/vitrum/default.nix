{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  ase,
  pandas,
  scikit-learn,
  scipy,
  pymatgen
}: buildPythonPackage {
  pname = "vc-sqnm";
  version = "24-11-05";
  src = fetchFromGitHub {
    owner = "R-Chr";
    repo = "vitrum";
    rev = "789115d";
    sha256 = "sha256-AcJTF2y9RJcgMbD+5JewwTDxf8oLFsNncPq9aL14WtA=";
  };
  
  # format = "pyproject";

  buildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
    ase
    pandas
    scikit-learn
    scipy
    pymatgen
  ];

  # doCheck = false;
}
