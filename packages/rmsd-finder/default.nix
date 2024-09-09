{
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  blas,
  lapack
}: stdenv.mkDerivation rec {

  pname = "rmsd-finder";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "Jonas-Finkler";
    repo = "RMSD-finder";
    rev = "v${version}";
    sha256 = "sha256-5k7g9gsHqeo3WKmAFcCRwgB8ESFpqtLz5WukCXPFWmY=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];
  
  buildInputs = [
    blas
    lapack
  ];

  cmakeFlags = [
    "-DEBUG=OFF"
    "-DINTEL=OFF"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp rmsdFinder $out/bin
  '';
}
