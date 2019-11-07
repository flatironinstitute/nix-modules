{ stdenv
, fetchFromGitHub
, python
}:

let version = "1.4"; in

stdenv.mkDerivation rec {
  name = "disBatch-${version}";
  src = fetchFromGitHub {
    owner = "flatironinstitute";
    repo = "disBatch";
    rev = version;
    fetchSubmodules = true;
    sha256 = "05wd3nalxq6s5navcblh0vlyqlq853v70dgc8js779mncm7pwkkf";
  };

  buildInputs = [python];

  builder = ./builder.sh;
}
