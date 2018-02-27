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
    sha256 = "1g94vka08mjfc78vwjlyagvqwhmdpv0jqb3xzw0j68i493qzlnvm";
  };

  buildInputs = [python];

  builder = ./builder.sh;
}
