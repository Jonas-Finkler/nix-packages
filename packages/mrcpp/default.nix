{
  stdenv, 
  fetchFromGitHub,
  cmake,
  python3,
  eigen,
  blas,
  catch2_3
}: stdenv.mkDerivation {
  pname = "mrcpp";
  version = "72013337";
  # version = "1.5.0";
  src = fetchFromGitHub {
    owner = "MRChemSoft";
    repo = "mrcpp";
    rev = "720133372c9717134c5a01e963cb9804a1e8c36e";
    sha256 = "sha256-Rsq6DVwhu9ojI+KWD/aVxdMcXaxpwsapdjUDpxTilJ8=";
    # rev = "v1.5.0";
    # sha256 = "sha256-U2vgu7cH+qzK1LueI1SlwlIx48n098m8xNbt/oUTnVI=";
  };
  nativeBuildInputs = [
    cmake
    python3
  ];
  
  buildInputs = [
    eigen
    blas
    catch2_3
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
}
