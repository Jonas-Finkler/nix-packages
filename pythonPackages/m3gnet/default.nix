{
  buildPythonPackage,
  fetchFromGitHub,
  pymatgen,
  tensorflow,
  ase,
  numpy, 
  monty,
  sympy,
}: buildPythonPackage rec {
  pname = "m3gnet";
  version = "1f89ecb";
  src = fetchFromGitHub {
    owner = "materialsvirtuallab";
    repo = "m3gnet";
    rev = "${version}";
    hash = "sha256-X0ms2U97Qzu5HsnlkiR8qBskCJqwMRKZBUcp/9R5FD4=";
    # fetchSubmodules = true;
    # deepClone = true;
  };
  format = "pyproject";
  
  buildInputs = [
  ];
  
  propagatedBuildInputs = [
    pymatgen
    tensorflow
    ase
    numpy
    monty
    sympy
  ];
  
  # doCheck = false;
}
  
