{
  buildPythonPackage,
  fetchFromGitHub,
  numpy, 
  h5py,
  fabio,
  numexpr,
  silx,
  scipy,
  matplotlib,
  meson,
  meson-python,
  wheel,
  ninja,
  cython,
  oldest-supported-numpy,
  python
}: buildPythonPackage rec {
  pname = "pyfai";
  version = "2025.03";
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
    repo = "pyFAI";
    rev = "v${version}";
    sha256 = "sha256-YPicFyTU0YcmBC21ae/Vb2UqWznh5zzQ4zaASetgTfM=";
    # fetchSubmodules = true;
    # deepClone = true;
  };
  
  format = "pyproject";
  # dontUseCmakeConfigure = true;

  # patchPhase = ''
  #   substituteInPlace meson.build \
  #     --replace './version.py --wheel' 'python version.py --wheel'
  # '';
  patchPhase = ''
    patchShebangs version.py
  '';

  nativeBuildInputs = [
    meson
    meson-python
    ninja
    wheel
    cython
    oldest-supported-numpy
    python
  ];

  # buildInputs = [
  #   cmake
  #   scikit-build
  # ];

  propagatedBuildInputs = [
    numpy
    h5py
    fabio
    silx
    scipy
    numexpr
    matplotlib

  ];

  # doCheck = false;
}
