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
      rev = "9dda41ca139e382d959a205a3b37ea5fd67bfccf";
      sha256 = "sha256-+9u2DDFrolpD4DxKHsNX2hQ0zA9zlah0I4LB7Va+p8A=";
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
