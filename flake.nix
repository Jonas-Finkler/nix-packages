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
      # Those have been merged into nixpkgs
      # sirius = pkgs.callPackage ./packages/sirius {};
      # umpire = pkgs.callPackage ./packages/umpire {};
    };

    myPythonPackages = pkgs: python: {
      sqnm = python.callPackage ./pythonPackages/sqnm {};
      ase-mh = python.callPackage ./pythonPackages/ase-mh {};
      kimpy = python.callPackage ./pythonPackages/kimpy {};
      torch-geometric = python.callPackage ./pythonPackages/torch-geometric {};
      torch-scatter = python.callPackage ./pythonPackages/torch-scatter {};

      # merged
      # sirius = python.toPythonModule (pkgs.sirius.override {
      #   enablePython = true; 
      #   pythonPackages = python.pythonPackages;
      # });
      sirius-python-interface = python.callPackage ./pythonPackages/sirius-python-interface {};
      torch-nl = python.callPackage ./pythonPackages/torch-nl {};
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
          packageOverrides = python-final: python-prev: (myPythonPackages final python-final);
        };
        python312 = prev.python312.override {
          packageOverrides = python-final: python-prev: (myPythonPackages final python-final);
        };
        python313 = prev.python313.override {
          packageOverrides = python-final: python-prev: (myPythonPackages final python-final);
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
        (python311.withPackages (p: with p; [
          # sqnm
          # ase-mh # there are some issues with the new ase version -> BE CAREFUL!
          # kimpy
          # sirius-python-interface
          # torch-nl
          torch-geometric
          torch-scatter
          # sw
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
