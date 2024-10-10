{ stdenv
, lib
, fetchFromGitHub
, gnused
, gnugrep
, writeShellScriptBin
}: stdenv.mkDerivation rec {

  pname = "sw";
  version = "01a3267";

  src = fetchFromGitHub {
    owner = "coryfklein";
    repo = pname;
    rev = "${version}";
    hash = "sha256-QlRBkOASniZ4rDPmc4q0wx7AN/A5mcvBW3WOta50PlA=";
  };

  buildInputs = [
    gnused
    gnugrep
  ];

  buildPhase = ''
    patchShebangs sw  
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/sw $out/bin
    chmod +x $out/bin/sw
  '';

  meta = with lib; {
    description = "Domain specific library for electronic structure calculations";
    homepage = "https://github.com/electronic-structure/SIRIUS";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
