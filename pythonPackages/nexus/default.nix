{
  buildPythonPackage,
  fetchgit,
  numpy,
  scipy,
  matplotlib, 
  ninja, 
  meson, 
  meson-python,
  setuptools,
  swig,
  pkg-config,
  eigen,
  ceres-solver,
  cmake,
  pybaselines,
}: buildPythonPackage rec {
  pname = "nexus";
  version = "1.2.0";
  # src = fetchFromGitLab {
  #   # https://codebase.helmholtz.cloud/DAPHNE4NFDI/nuclear-nexus.git
  #   owner = "DAPHNE4NFDI";
  #   repo = "nuclear-nexus";
  #   rev = "4f170bb1"; #"v${version}";
  #   sha256 = "";
  #   # fetchSubmodules = true;
  #   # deepClone = true;
  # };
  src = fetchgit {
    url = "https://codebase.helmholtz.cloud/DAPHNE4NFDI/nuclear-nexus.git";
    # rev = "v${version}";
    rev = "b9c708c8dbe11407980c0829550118b4aba13671";
    # sha256 = "sha256-fn3FnxJ/g8uryiHWz0Z3qLho57zf/smNRfnxRv61kOk="; # 1.1.1
    # sha256 = "sha256-p70RCLsNJ7K7/URuk6HSJWW+7tZojIVDIgQKz8FkjkM="; # 1.2.0
    sha256 = "sha256-08uVzZBxW7ZFkr8EBCQi/uZYFcW/7CUHbPRrbx34yDY=";
  };
  format = "pyproject";
  
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    ninja
    meson
    meson-python
    setuptools
    swig
    pkg-config
    cmake
  ];
  
  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    eigen
    ceres-solver
    pybaselines
  ];
  
  # doCheck = false;
}
  
