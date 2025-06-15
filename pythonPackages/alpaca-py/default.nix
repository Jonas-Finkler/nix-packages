{
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  requests,
  pydantic,
  pandas,
  msgpack,
  websockets,
  sseclient-py
}: buildPythonPackage rec {
  pname = "alpaca-py";
  version = "0.40.1";
  src = fetchFromGitHub {
    owner = "alpacahq";
    repo = "alpaca-py";
    rev = "v${version}";
    sha256 = "sha256-v3oaMRnsf1I79xBv6g/xbVsdK1mFPaPUfYD+i79fXbE=";
    # fetchSubmodules = true;
    # deepClone = true;
  };
  format = "pyproject";

  
  buildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];
  
  propagatedBuildInputs = [
    requests
    pydantic
    pandas
    msgpack
    websockets
    sseclient-py
  ];
  
  # doCheck = false;
}
  
