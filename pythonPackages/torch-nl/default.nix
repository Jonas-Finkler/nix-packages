{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  ninja,
  ase,
  numpy, 
  torch,
  pytest,
  black,
  pytestCheckHook
}: buildPythonPackage rec {
  pname = "torch-nl";
  version = "0.3";
  src = fetchFromGitHub {
    owner = "felixmusil";
    repo = "torch_nl";
    rev = "v${version}";
    hash = "sha256-LJIJNqcDe83cs8gN2Pv8xmOkmyDMqKrNhYYd/9qSaVM=";
  };
  format = "pyproject";

  testInputs = [
    pytestCheckHook
  ];
  
  buildInputs = [
    setuptools
    wheel
    ninja
  ];
  
  propagatedBuildInputs = [
    ase
    numpy
    torch
    black
    pytest # NOTE: Should not be a runtime dependency but thats how it is in upstream
  ];
  
}
  
