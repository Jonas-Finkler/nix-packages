{
  lib,
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
  pagmo2,
  pygmo,
  nlopt,
  boost,
  tbb,
  ipopt,
}: buildPythonPackage rec {
  pname = "nexus";
  version = "latest_26.08.2025";

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

  mesonFlags = [
    # those should be on by default if dependencies are found but it is useful for testing to force it
    "-Dpagmo=enabled"
    "-Dnlopt=enabled" 
    "--wrap-mode=nofallback" # don't try to download dependencies
    # This path is not included by default causing error when including pagmo
    "-Dc_args=-I${ipopt}/include/coin-or"
  ];

  nativeBuildInputs = [
    ninja
    meson
    meson-python
    setuptools
    swig
    pkg-config
    cmake
  ];

  buildInputs = [
    eigen
    ceres-solver
    nlopt
    tbb
    pagmo2
    pygmo
    boost
    ipopt
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    pybaselines
  ];

  meta = with lib; {
    description = "Nexus is a flexible and performant package to simulate and fit Moessbauer and nuclear resonant scattering experiments while offering an easy to use Python interface to set up the calculations.";
    homepage = "https://fs-mcp.pages.desy.de/nuclear-nexus/index.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };

}
  
