{
  buildPythonPackage,
  fetchFromGitHub,
  sirius,
  setuptools,
  sqnm,
  mpi4py,
  numpy,
  ase,
  h5py,
}: buildPythonPackage {
  pname = "sirius-python-interface";
  version = "5aee8e5";
  src = fetchFromGitHub {
    owner = "moritzgubler";
    repo = "sirius-python-interface";
    rev = "5aee8e5";
    sha256 = "sha256-NHKCB+7b5xDKIOixZZUqniDPNvat5Pc73OKbY2levAE=";
    # fetchSubmodules = true;
    # deepClone = true;
  };
  
  buildInputs = with [
    setuptools
  ];

  propagatedBuildInputs = [
    mpi4py
    numpy
    ase
    h5py
    sqnm
    sirius
  ];



}