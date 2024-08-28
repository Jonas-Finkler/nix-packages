{
  stdenv, 
  cmake, 
  gfortran,
  gcc,
  blas,
  lapack,
  scalapack,
  mpi
}: stdenv.mkDerivation {
  pname = "fhi-aims";
  version = "22/03/22";
  src = ./fhi-aims.210716_3.tgz;

  nativeBuildInputs = [
    cmake
    gfortran
    gcc
    # perl
  ];
  
  buildInputs = [
    blas
    lapack
    scalapack
    mpi
  ];

  # postPatch = ''
  #   patchShebangs src/version_stamp_writer.pl
  #   patchShebangs src/generate-dependencies.pl
  # '';

  # there is a problem how the nix cmake handles spaces in the cmakeFlags.
  # This is a work around.j
  preConfigure = let
    fflags = "-ffree-line-length-none -Wno-error -fallow-argument-mismatch";
    # -flto -Ofast
  in ''
    cmakeFlagsArray+=(
    "-DCMAKE_Fortran_FLAGS:STRING='${fflags} -O3'" 
    "-DFortran_MIN_FLAGS:STRING='${fflags} -O0'"
    "-DCMAKE_C_FLAGS:STRING=' '"
    "-DLIB_PATHS='${blas}/lib ${lapack}/lib ${scalapack}/lib'"
    "-DLIBS='blas lapack scalapack'"
    )
  '';

  cmakeFlags = [
    # GNU Compilers
    "-DCMAKE_Fortran_COMPILER=mpif90"
    "-DCMAKE_C_COMPILER=gcc"
    "-DUSE_MPI=ON"
    "-DUSE_SCALAPACK=ON"
    "-DUSE_LIBXC=ON"
    "-DUSE_HDF5=OFF"
    "-DUSE_RLSY=ON"
    "-DELPA2_KERNEL=''" # change to AVX, AVX2 or AVX512
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp *.x $out/bin/
    ln -s $out/bin/aims.210716_3.scalapack.mpi.x $out/bin/aims.scalapack.mpi.x
  '';

}
