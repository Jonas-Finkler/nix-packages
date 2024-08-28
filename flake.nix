{
  description = "Collection of Jonas Finkler's nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        myPythonPackages = {
          sqnm = pkgs.callPackage ./pythonPackages/sqnm {};
        };

        fhiaims = pkgs.callPackage ./packages/fhiaims {};
      in {
        packages = { inherit fhiaims; };
        # defaultPackage = xxx;
        # devShells.default = pkgs.mkShell {
        #   buildInputs = [ ];
        # };
      }
    );
}
