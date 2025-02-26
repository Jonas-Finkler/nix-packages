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
    rev = "8d727708e7531f41262c88368a777091afe8a072";
    sha256 = "sha256-hqsmzSmAMDiykmBlG32xw3NjSSuRpbj/WepuGCCjK/4=";
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
