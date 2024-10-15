{
  buildPythonPackage,
  fetchFromGitHub,
  torch,
  setuptools,
  which
}: buildPythonPackage rec {

  pname = "torch-scatter";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "rusty1s";
    repo = "pytorch_scatter";
    rev = "${version}";
    hash = "sha256-dmJrsWoFsqFlrgfbFHeD5f//qUg0elmksIZG8vXXShc=";
  };

  format = "pyproject";

  pythonImportsCheck = [ "torch_scatter" ];
  
  # pytest adds pwd to path, causing import errors
  # https://github.com/NixOS/nixpkgs/issues/255262
  # preCheck = ''
  #   cd tests
  # '';

  doCheck = false;

  nativeCheckInputs = [ 
  ];

  nativeBuildInputs = [
    setuptools
    which
  ];
  
  buildInputs = [
  ];
  
  propagatedBuildInputs = [
    torch
  ];
}
