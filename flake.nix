{
  description = "Collection of Jonas Finkler's nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, flake-utils, ... }: let
    myPackages = pkgs: {
      fhiaims = pkgs.callPackage ./packages/fhiaims {};
      runner = pkgs.callPackage ./packages/runner {};
      kim-api = pkgs.callPackage ./packages/kim-api {};
      mrcpp = pkgs.callPackage ./packages/mrcpp {};
      xcfun = pkgs.callPackage ./packages/xcfun {};
      mrchem = pkgs.callPackage ./packages/mrchem {};
      rmsd-finder = pkgs.callPackage ./packages/rmsd-finder {};
      sw = pkgs.callPackage ./packages/sw {};
      # fiji = pkgs.callPackage ./packages/fiji {}; # has been merged https://github.com/NixOS/nixpkgs/pull/363577
      # Those have been merged into nixpkgs
      # sirius = pkgs.callPackage ./packages/sirius {};
      # umpire = pkgs.callPackage ./packages/umpire {};
    };

    myPythonPackages = pkgs: python-final: python-prev: {
      sqnm = python-final.callPackage ./pythonPackages/sqnm {};
      ase-mh = python-final.callPackage ./pythonPackages/ase-mh {};
      kimpy = python-final.callPackage ./pythonPackages/kimpy {};
      torch-geometric = python-final.callPackage ./pythonPackages/torch-geometric {};
      torch-scatter = python-final.callPackage ./pythonPackages/torch-scatter {};
      vitrum = python-final.callPackage ./pythonPackages/vitrum {}; # NOTE: Misses dependencies
      lammps = python-prev.lammps.overrideAttrs {lammps = pkgs.lammps-mpi; };
      alpaca-py = python-final.callPackage ./pythonPackages/alpaca-py {};

      # merged
      # sirius = python.toPythonModule (pkgs.sirius.override {
      #   enablePython = true; 
      #   pythonPackages = python.pythonPackages;
      # });
      sirius-python-interface = python-final.callPackage ./pythonPackages/sirius-python-interface {};
      torch-nl = python-final.callPackage ./pythonPackages/torch-nl {};
      msdnet = python-final.callPackage ./pythonPackages/msdnet {};
    };

    # normal packages
    packageOverlays = [
      (final: prev: 
        (myPackages final)
      )
      # lammps with openkim enabled
      (import ./overlays/lammps.nix)
    ];

    pythonOverlays = [
      # python packages
      (final: prev: {
        python311 = prev.python311.override {
          packageOverrides = python-final: python-prev: (myPythonPackages final python-final python-prev);
        };
        python312 = prev.python312.override {
          packageOverrides = python-final: python-prev: (myPythonPackages final python-final python-prev);
        };
        python313 = prev.python313.override {
          packageOverrides = python-final: python-prev: (myPythonPackages final python-final python-prev);
        };
      })
    ];

    overlays = packageOverlays ++ pythonOverlays;

  in { 
    # basic flake output
    inherit overlays;

    inherit packageOverlays;

    pythonPackages = myPythonPackages;

  } // (flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      inherit overlays;
      # # cuda
      # config = {
      #   allowUnfree = true;
      #   cudaSupport = true;
      #   cudaVersion = "12.6.0";
      #   # cudaVersion = "12.6.0-v100";
      # };
    };
  in {
    # system specific output
    packages = with pkgs; { 
      inherit fhiaims; 
      inherit runner;
      inherit kim-api;
      inherit mrchem;
      # inherit sirius;  # merged
      inherit umpire;
      inherit rmsd-finder;
      inherit lammps;
      inherit lammps-mpi;
      inherit sw;
      singularityContainer = pkgs.singularity-tools.buildImage {
        name = "fhi-aims";
        contents = (with pkgs; [
          coreutils-full # provides ls, cat, ...
          fhiaims
        ]);
        # the shadowSetup creates passwd and group files to prevent singularity from complaining
        runAsRoot = ''
          #!${pkgs.stdenv.shell}
          ${pkgs.dockerTools.shadowSetup} 
        '';
        # drop into shell by default
        runScript = ''
          #!${pkgs.stdenv.shell}
          # export CC=${pkgs.cudaPackages.backendStdenv.cc}/bin/cc;
          # export CXX=${pkgs.cudaPackages.backendStdenv.cc}/bin/c++;
          exec /bin/sh $@"
        '';
        diskSize = 1024 * 40;
        memSize = 1024 * 8;
      };
    };
    # defaultPackage = xxx;

    # for testing that everything compiles
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [ 
        # lammps
        # lammps-mpi
        # fhiaims
        # runner
        # kim-api
        # mrchem
        # # sirius # from nixpkgs
        # umpire
        # rmsd-finder
        # sw
        # fiji
        (python311.withPackages (p: with p; [
          # sqnm
          # ase-mh # there are some issues with the new ase version -> BE CAREFUL!
          # kimpy
          # sirius-python-interface
          # torch-nl
          # torch-geometric
          # torch-scatter
          # vitrum
          # sw
          # lammps
          alpaca-py
        ]))
      ];

      shellHook = ''
        export FLAKE="Jonas nixpkgs test shell"
        # OMP
        export OMP_NUM_THREADS=4
        # back to zsh
        exec zsh
      '';
    };
  }));
}
