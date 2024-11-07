{
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  setuptools,
  pybind11,
  kim-api,
  numpy,
  pytestCheckHook,
  ase
}: buildPythonPackage rec {

  pname = "kimpy";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "openkim";
    repo = "kimpy";
    rev = "v${version}";
    hash = "sha256-GTy0HtukUSQl/DseGZklt4XnzsWdBL0MvU+jW9g47/8=";
  };

  format = "pyproject";

  pythonImportsCheck = [ "kimpy" ];
  
  # pytest adds pwd to path, causing import errors
  # https://github.com/NixOS/nixpkgs/issues/255262
  preCheck = ''
    cd tests
  '';

  nativeCheckInputs = [ 
    pytestCheckHook 
    ase
  ];

  nativeBuildInputs = [
    pkg-config
    setuptools
  ];
  
  buildInputs = [
    pybind11
    kim-api
  ];
  
  propagatedBuildInputs = [
    numpy
  ];
}
