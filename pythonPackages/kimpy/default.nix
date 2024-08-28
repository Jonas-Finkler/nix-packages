{
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  setuptools,
  pybind11,
  kim-api,
  numpy
}: buildPythonPackage {
  pname = "kimpy";
  version = "2.1.1";
  src = fetchFromGitHub {
    owner = "openkim";
    repo = "kimpy";
    rev = "v2.1.1";
    sha256 = "sha256-GTy0HtukUSQl/DseGZklt4XnzsWdBL0MvU+jW9g47/8=";
    # fetchSubmodules = true;
    # deepClone = true;
  };
  format = "pyproject";
  
  nativeBuildInputs = [
    # needs to be placed in nativeBIs to work (hooks?)
    pkg-config
  ];
  
  buildInputs = [
    setuptools
  ];
  
  propagatedBuildInputs = [
    pybind11
    kim-api
    numpy
  ];
  
  # preBuild = ''
  #   export PKG_CONFIG_PATH="${kim-api}/lib/pkgconfig:"
  # '';
  
  # prePatch = ''
  #   substituteInPlace setup.py \
  #     --replace 'pkg-config' '${pkgs.pkg-config}/bin/pkg-config'
  # '';
  
  # doCheck = false;
}
