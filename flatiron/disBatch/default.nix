{ stdenv
, fetchFromGitHub
, python
}:

let version = "1.3"; in

stdenv.mkDerivation rec {
  name = "disBatch-${version}";
  src = fetchFromGitHub {
    owner = "flatironinstitute";
    repo = "disBatch";
    rev = version;
    fetchSubmodules = true;
    sha256 = "1zvwq7b1vw96ra9mdgll6f6q32z0c8ck05ggy2r9kihyn30i1z3d";
  };

  buildInputs = [python];

  builder = ./builder.sh;
}
