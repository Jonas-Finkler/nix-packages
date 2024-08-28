{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  curl,
  gnused,
  gnutar,
  xz,
  gnumake,
  gnugrep,
  cacert,
  pkg-config,
  gfortran,
  makeWrapper
}: stdenv.mkDerivation {
          pname = "kim-api";
          version = "2.3.0";
          src = fetchFromGitHub {
            owner = "openkim";
            repo = "kim-api";
            rev = "v2.3.0";
            sha256 = "sha256-U438tEYg53QZ9apVPm9QwTRRbaTBT+pju2ct9dPSgao=";
            # fetchSubmodules = true;
            # deepClone = true;

          };

          # So the script can use cmake 
          # Maybe the same should be done for curl? 
          # prePatch = ''
          #   substituteInPlace utils/collections-management.in \
          #     --replace 'cmake_command="cmake"' 'cmake_command="${pkgs.cmake}/bin/cmake"'
          #     --replace 'curl' '${pkgs.curl}'
          # '';
          postInstall = ''
            wrapProgram $out/bin/kim-api-collections-management \
              --prefix PATH : ${lib.makeBinPath [ 
                cmake 
                curl 
                gnused 
                gnutar
                xz
                gnumake
                gnugrep
              ]} \
              --prefix CMAKE_PREFIX_PATH : $out \
              --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
          '';

          nativeBuildInputs = [
            pkg-config
            gfortran
            cmake
            makeWrapper
          ];
          
          buildInputs = [
            # cmake
            # curl
            # gnused
            cacert
          ];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
          ];

        };
