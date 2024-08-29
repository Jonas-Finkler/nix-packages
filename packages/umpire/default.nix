{ 
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  config,
  gpuBackend ? (
    if config.cudaSupport
    then "cuda"
    # else if config.rocmSupport
    # then "rocm"
    else "none"
  ),
  cudaPackages
}: stdenv.mkDerivation rec {
  pname = "umpire";
  version = "2024.02.1";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "umpire";
    rev = "v${version}";
    hash = "sha256-cIUGlRNdbddxcC0Lj0co945RlHcPrDLo+bZIsUB9im4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ 
    cmake 
  ] ++ lib.optional (gpuBackend == "cuda") cudaPackages.cuda_nvcc;

  buildInputs = [ 
  ] ++ lib.optionals (gpuBackend == "cuda") [
    cudaPackages.cudatoolkit
  ];

  cmakeFlags = [
  ] ++ lib.optionals (gpuBackend == "cuda") [
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
    # not sure the flags below are even needed (or even the cudatoolkit dependency)
    "-DCMAKE_CUDA_ARCHITECTURES='70;72;75;80'" # Volta (70, 72), Turing (75), Ampere (80)
    "-DENABLE_CUDA=ON"
  ];

  meta = with lib; {
    description = "Application-focused API for memory management on NUMA & GPU architectures";
    homepage = "https://github.com/LLNL/Umpire";
    maintainers = with maintainers; [ sheepforce ];
    license = with licenses; [ mit ];
    platforms = [ "x86_64-linux" ];
  };
}
