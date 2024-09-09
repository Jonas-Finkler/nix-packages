{
  stdenv, 
  fetchFromGitHub,
  cmake,
  python3
}: stdenv.mkDerivation rec {
  pname = "xcfun";
  version = "2.1.1";
  
  src = fetchFromGitHub {
    owner = "dftlibs";
    repo = "xcfun";
    rev = "v${version}";
    sha256 = "sha256-LfZ3M+rWvom5hhyfRk/Aii92KOcIpS6Aj9/ABS0DR64=";
  };
  nativeBuildInputs = [
    cmake
    python3
  ];
  
  buildInputs = [
  ];
  
  dontUseCmakeConfigure = true;
  configurePhase = ''
    python3 ./setup \
      --extra-cxx-flags="-march=znver2" \
      --type=release \
      --prefix=$out
    cd build
  '';
}
