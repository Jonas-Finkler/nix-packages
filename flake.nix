{
  description = "Collection of Jonas Finkler's nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        myPackages = pkgs: {
          fhiaims = pkgs.callPackage ./packages/fhiaims {};
          runner = pkgs.callPackage ./packages/runner {};
          kim-api = pkgs.callPackage ./packages/kim-api {};
          mrcpp = pkgs.callPackage ./packages/mrcpp {};
          xcfun = pkgs.callPackage ./packages/xcfun {};
          mrchem = pkgs.callPackage ./packages/mrchem {};
        };

        myPythonPackages = python: {
          sqnm = python.callPackage ./pythonPackages/sqnm {};
          sirius-python-interface = python.callPackage ./pythonPackages/sirius-python-interface {};
          ase-mh = python.callPackage ./pythonPackages/ase-mh {};
          kimpy = python.callPackage ./pythonPackages/kimpy {};
        };

        overlays = [
          (final: prev: 
            # normal packages
            (myPackages pkgs) // {
            # python packages
            python311 = prev.python311.override {
              packageOverrides = python-self: python-super: (myPythonPackages python-self);
            };
            python312 = prev.python312.override {
              packageOverrides = python-self: python-super: (myPythonPackages python-self);
            };
          })
        ];

        pkgs = import nixpkgs {
          inherit system;
          inherit overlays;
        };


      in rec {

        inherit overlays;

        packages = with pkgs; { 
          inherit fhiaims; 
          inherit runner;
          inherit kim-api;
          inherit mrchem;
        };
        # defaultPackage = xxx;

        # for testing that everything compiles
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ 
            fhiaims
            runner
            kim-api
            mrchem
            (python311.withPackages (p: with p; [
              sqnm
              sirius-python-interface
              ase-mh # there are some issues with the new ase version -> BE CAREFUL!
              kimpy
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
      }
    );
}
