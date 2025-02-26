{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cmake,
  scikit-build,
  numpy,
  scikit-image,
  psutil,
  h5py,
  tqdm,
  numba,
  cudatoolkit,
  imageio
}: buildPythonPackage rec {
  pname = "msdnet";
  version = "2.0.0";
  # src = fetchFromGitHub {
  #   owner = "dmpelt";
  #   repo = "msdnet";
  #   rev = "v${version}";
  #   sha256 = "sha256-KetDjiEhSrzBSbTJuoyXM0ErUkIKth2NHYJtW1BFxJs=";
  #   # fetchSubmodules = true;
  #   # deepClone = true;
  # };
  src = fetchFromGitHub {
    owner = "Jonas-Finkler";
    repo = "msdnet";
    rev = "75fe55db2f164eb793ab5dbdac3506bc0ff774ea";
    sha256 = "sha256-IlP6fys3ofBagYoaBaljvyAk7eTqipK6BOG7ZnlVaJA=";
    # fetchSubmodules = true;
    # deepClone = true;
  };
  
  # format = "pyproject";
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    setuptools
    cmake
    scikit-build
  ];

  # buildInputs = [
  #   cmake
  #   scikit-build
  # ];

  propagatedBuildInputs = [
    numpy
    scikit-image
    psutil
    h5py
    tqdm
    numba
    cudatoolkit
    imageio
  ];

  # doCheck = false;
}
