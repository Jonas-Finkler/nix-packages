{
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  blas,
  lapack
}: stdenv.mkDerivation {

  pname = "rmsd-finder";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "Jonas-Finkler";
    repo = "RMSD-finder";
    rev = "v1.0.0";
    sha256 = "sha256-tPsSfHRjSBNBxmQcJukpLXcGUMujv8+WIHsuDuyYN30=";
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
