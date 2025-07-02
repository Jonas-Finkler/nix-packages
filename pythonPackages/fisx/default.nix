{
  buildPythonPackage,
  fetchFromGitHub,
  wheel,
  cython,
  setuptools,
  pybind11,
  kim-api,
  numpy,
}: buildPythonPackage rec {

  pname = "fisx";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "vasole";
    repo = "fisx";
    rev = "v${version}";
    hash = "sha256-CqSmQSoaPEztxEahH4fgfZ0eumhwCLGlWlKw9N9L/Ac=";
  };

  # format = "pyproject";

  pythonImportsCheck = [ "fisx" ];
  
  # pytest adds pwd to path, causing import errors
  # https://github.com/NixOS/nixpkgs/issues/255262
  # preCheck = ''
  #   cd tests
  # '';

  # nativeCheckInputs = [ 
  #   pytestCheckHook 
  # ];

  nativeBuildInputs = [
    wheel
    setuptools
    cython
  ];
  
  buildInputs = [
    pybind11
    kim-api
  ];
  
  propagatedBuildInputs = [
    numpy
  ];
}
