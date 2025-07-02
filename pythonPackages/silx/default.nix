{
  buildPythonPackage,
  fetchFromGitHub,
  numpy, 
  h5py,
  fabio,
  packaging,
  meson-python,
  cython,
}: buildPythonPackage rec {
  pname = "silx";
  version = "2.2.2";
  # src = fetchFromGitHub {
  #   owner = "dmpelt";
  #   repo = "msdnet";
  #   rev = "v${version}";
  #   sha256 = "sha256-KetDjiEhSrzBSbTJuoyXM0ErUkIKth2NHYJtW1BFxJs=";
  #   # fetchSubmodules = true;
  #   # deepClone = true;
  # };
  src = fetchFromGitHub {
    owner = "silx-kit";
    repo = "silx";
    rev = "v${version}";
    sha256 = "";
    # fetchSubmodules = true;
    # deepClone = true;
  };
  
  format = "pyproject";
  # dontUseCmakeConfigure = true;


  nativeBuildInputs = [
    meson-python
    cython
    # oldest-supported-numpy
    # python
  ];

  # buildInputs = [
  #   cmake
  #   scikit-build
  # ];

  propagatedBuildInputs = [
    numpy
    packaging
    h5py
    fabio
  ];

  # doCheck = false;
}
