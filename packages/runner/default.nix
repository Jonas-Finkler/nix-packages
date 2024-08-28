{
  stdenv,
  blas,
  lapack,
  gfortran
}: stdenv.mkDerivation {
  pname = "RuNNer";
  version = "fcf5d7e3";
  src = ./RuNNer.tgz;

  preConfigure = ''
    cd src-devel
  '';

  preBuild = ''
    makeFlagsArray+=(
      FC=gfortran 
      USE_MPI=no
          FFLAGS="-O3 -llapack -lblas -fopenmp -Wno-error -fallow-argument-mismatch"
      FFLAGS_MPI="-O3 -llapack -lblas -fopenmp -Wno-error -fallow-argument-mismatch"
      CFLAGS="-O3"
      LIB="-L${blas}/lib -L${lapack}/lib"
      serial
      )
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp RuNNer.serial.x $out/bin
  '';

  nativeBuildInputs = [
    gfortran
  ];
  
  buildInputs = [
    blas
    lapack
  ];

}

