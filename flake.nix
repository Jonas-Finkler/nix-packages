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
      sirius = pkgs.callPackage ./packages/sirius {};
      umpire = pkgs.callPackage ./packages/umpire {};
    };

    myPythonPackages = pkgs: python: {
      sqnm = python.callPackage ./pythonPackages/sqnm {};
      ase-mh = python.callPackage ./pythonPackages/ase-mh {};
      kimpy = python.callPackage ./pythonPackages/kimpy {};
      sirius = python.toPythonModule (pkgs.sirius.override {
        enablePython = true; 
        pythonPackages = python.pythonPackages;
      });
      sirius-python-interface = python.callPackage ./pythonPackages/sirius-python-interface {};
    };

    overlays = [
      # normal packages
      (final: prev: 
        (myPackages final)
      )
      # python packages
      (final: prev: {
        python311 = prev.python311.override {
          packageOverrides = python-self: python-super: (myPythonPackages final python-self);
        };
        python312 = prev.python312.override {
          packageOverrides = python-self: python-super: (myPythonPackages final python-self);
        };
      })
      # lammps with openkim enabled
      (import ./overlays/lammps.nix)
    ];

  in { 
    # basic flake output
    inherit overlays;

  } // (flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      inherit overlays;
      config = {
        allowUnfree = true;
        cudaSupport = true;
        # cudaVersion = "12.6.0-v100";
        cudaVersion = "12.6.0";
      };
    };
  in {
    # system specific output
    packages = with pkgs; { 
      inherit fhiaims; 
      inherit runner;
      inherit kim-api;
      inherit mrchem;
      inherit sirius;
      inherit umpire;
      inherit lammps;
    };
    # defaultPackage = xxx;

    # for testing that everything compiles
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [ 
        # fhiaims
        # runner
        # kim-api
        # mrchem
        # sirius
        # umpire
        (python311.withPackages (p: with p; [
          # sqnm
          # ase-mh # there are some issues with the new ase version -> BE CAREFUL!
          # kimpy
          # sirius-python-interface
        ]))
        lammps
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
