{
  stdenv,
  blas,
  lapack,
  gfortran
}: stdenv.mkDerivation {
  pname = "RuNNer";
  version = "fcf5d7e3";
  
  src = builtins.fetchGit {
    url = "git@github.com:Jonas-Finkler/RuNNer.git";
    ref = "master";
    rev = "fcf5d7e322cc10e32705151591e36784a3915a23";
  };

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

