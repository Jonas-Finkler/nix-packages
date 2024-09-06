final: prev: {
  lammps = prev.lammps.override {
    packages = prev.lammps.packages // {
      KIM = true;
    };
    extraBuildInputs = prev.lammps.extraBuildInputs ++ [
      final.kim-api
    ];
  };
}
