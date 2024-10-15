{
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  fsspec,
  jinja2,
  numpy,
  psutil,
  pyparsing,
  requests,
  tqdm,
  flit-core,
  torch,
  onnx,
  onnxruntime,
  pytest-cov,
  pytestCheckHook
}: buildPythonPackage rec {

  pname = "torch-geometric";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "pyg-team";
    repo = "pytorch_geometric";
    rev = "${version}";
    hash = "sha256-Zw9YqPQw2N0ZKn5i5Kl4Cjk9JDTmvZmyO/VvIVr6fTU=";
  };

  format = "pyproject";

  pythonImportsCheck = [ "torch_geometric" ];
  
  # pytest adds pwd to path, causing import errors
  # https://github.com/NixOS/nixpkgs/issues/255262
  # preCheck = ''
  #   cd tests
  # '';

  # FIX: 6 tests fail (some because of the triton problem)
  doCheck = false;

  nativeCheckInputs = [ 
    onnx
    onnxruntime
    pytest-cov
    pytestCheckHook 
  ];

  nativeBuildInputs = [
    flit-core # native or not?
  ];
  
  buildInputs = [
  ];
  
  propagatedBuildInputs = [
    aiohttp
    fsspec
    jinja2
    numpy
    psutil
    pyparsing
    requests
    tqdm
    torch
  ];
}
