{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gfortran,
  pkg-config,
  blas,
  lapack,
  gsl,
  libxc,
  hdf5,
  umpire,
  mpi,
  spglib,
  spfft,
  spla,
  costa,
  scalapack,
  boost,
  eigen,
  libvdwxc,
  cudaPackages,
  rocmPackages,
  enablePython ? false,
  pythonPackages, 
  mpiCheckPhaseHook,
  openssh,
  config,
  gpuBackend ? (
    if config.cudaSupport
    then "cuda"
    else if config.rocmSupport
    then "rocm"
    else "none"
  )
}: stdenv.mkDerivation {
  pname = "sirius";
  version = "7.6.0";
  src = fetchFromGitHub {
    owner = "electronic-structure";
    repo = "SIRIUS";
    rev = "v7.6.0";
    sha256 = "sha256-AdjqyHZRMl9zxwuTBzNXJkPi8EIhG/u98XJMEjHi/6k=";
    # fetchSubmodules = true;
    # deepClone = true;
  };
  
  nativeBuildInputs = [
    cmake
    gfortran
    pkg-config
  ] ++ lib.optional (gpuBackend == "cuda") cudaPackages.cuda_nvcc;
  
  buildInputs = [
    blas
    lapack
    gsl
    libxc
    hdf5
    umpire
    mpi
    spglib
    spfft
    spla
    costa
    scalapack
    boost
    eigen
    libvdwxc
  ] ++ lib.optionals enablePython [
    pythonPackages.python
  ] ++ lib.optionals (gpuBackend == "cuda") [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_profiler_api
    cudaPackages.cudatoolkit
    cudaPackages.libcublas
  ] ++ lib.optionals (gpuBackend == "rocm") [
    rocmPackages.clr
    rocmPackages.rocblas
  ];
  
  propagatedBuildInputs = [
   (lib.getBin mpi)
  ] ++ lib.optionals enablePython (with pythonPackages; [
    mpi4py
    pybind11
    h5py
  ]);
  
  CXXFLAGS = [
    # GCC 13: error: 'uintptr_t' in namespace 'std' does not name a type
    "-include cstdint"
  ];
  
  cmakeFlags = [
    "-DSIRIUS_USE_SCALAPACK=ON"
    "-DSIRIUS_BUILD_TESTING=ON"
    "-DSIRIUS_USE_VDWXC=ON"
    "-DSIRIUS_CREATE_FORTRAN_BINDINGS=ON"
    "-DSIRIUS_USE_OPENMP=ON"
    "-DSIRIUS_BUILD_TESTING=ON"
  ] ++ lib.optionals (gpuBackend == "cuda") [
    "-DSIRIUS_USE_CUDA=ON"
    "-DCMAKE_CUDA_ARCHITECTURES='70;72;75;80'" # Volta (70, 72), Turing (75), Ampere (80)
    "-DSIRIUS_USE_MEMORY_POOL=OFF"             # Trying to disable this because umpire throws errors (might be worth compiling umpire with CUDA?)
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
  ] ++ lib.optionals (gpuBackend == "rocm") [
    "-DSIRIUS_USE_ROCM=ON"
    "-DHIP_ROOT_DIR=${rocmPackages.clr}"
  ] ++ lib.optionals enablePython [
    "-DSIRIUS_CREATE_PYTHON_MODULE=On"
  ];
  
  doCheck = true;
  
  # Can not run parallel checks generally as it requires exactly multiples of 4 MPI ranks
  # Even cpu_serial tests had to be disabled as they require scalapack routines in the sandbox
  # and run into the same problem as MPI tests
  checkPhase = ''
    runHook preCheck
  
    ctest --output-on-failure --label-exclude integration_test
  
    runHook postCheck
  '';
  
  nativeCheckInputs = [
    mpiCheckPhaseHook
    openssh
  ];
}

