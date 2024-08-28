{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy

}: buildPythonPackage {
  pname = "vc-sqnm";
  version = "1.2";
  src = let
    repo = fetchFromGitHub {
      owner = "moritzgubler";
      repo = "vc-sqnm";
      rev = "v1.2";
      sha256 = "sha256-XTCpDjEveDeego1ZAHAkUnO2IdVnwD7I0Z12CSeSkAc=";
      # fetchSubmodules = true;
      # deepClone = true;
    };
  in 
    "${repo}/src/python/";
  
  # format = "pyproject";

  buildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
  ];

  # doCheck = false;
}
