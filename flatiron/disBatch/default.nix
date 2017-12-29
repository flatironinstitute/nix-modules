{ stdenv
, fetchFromGitHub
, python
}:

let version = "1.1"; in

stdenv.mkDerivation rec {
  name = "disBatch-${version}";
  src = fetchFromGitHub {
    owner = "flatironinstitute";
    repo = "disBatch";
    rev = version;
    fetchSubmodules = true;
  };

  buildInputs = [python];

  builder = ./builder.sh;
}
