{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, hatchling
, hatch-vcs
}:

buildPythonPackage rec {
  pname = "pybaselines";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "derb12";
    repo = "pybaselines";
    rev = "v${version}";
    sha256 = "sha256-Gj0vEBVBsixA1dY0LpcbgsguTUY2TVgOzvAqY+vkpGM=";
  };

  format = "pyproject";

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  nativeBuildInputs = [ 
    hatchling 
    hatch-vcs
  ];


  meta = with lib; {
    description = "Library of algorithms for baseline correction of experimental data";
    homepage = "https://github.com/derb12/pybaselines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
