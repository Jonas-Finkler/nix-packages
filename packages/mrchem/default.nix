{
  stdenv,
  fetchFromGitHub,
  pkgs,
  cmake,
  gfortran,
  blas,
  lapack,
  nlohmann_json,
  xcfun,
  mrcpp,
  eigen,
  python3
}: stdenv.mkDerivation {
  pname = "mrchem";
  version = "surface-forces-9408238";
  src = fetchFromGitHub {
    owner = "moritzgubler";
    repo = "mrchem";
    rev = "9408238bf3d75ca4e791afde3fb5cdce1d88de24";
    sha256 = "sha256-1XhPw/mfG5jG3cUIvyHLuJHHZ4MNkic9FrP8YoHP+08=";
    # fetchSubmodules = true;
    # deepClone = true;
  
  };
  
  nativeBuildInputs = with pkgs; [
    cmake
    gfortran
  ];
  
  buildInputs = with pkgs; [
    blas
    lapack
    nlohmann_json
    xcfun
    mrcpp
    eigen
    python3
  ];
  
  dontUseCmakeConfigure = true;
  
  configurePhase = ''
    python3 ./setup \
      --omp \
      --arch-flags=False \
      --extra-cxx-flags="-march=znver2" \
      --type=release \
      --prefix=$out
    cd build
  '';
  
  postInstall = ''
    patchShebangs --host $out/bin/mrchem
  '';
}
