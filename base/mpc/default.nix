{ stdenv
, fetchurl
, gmp
, mpfr
}:

stdenv.mkDerivation rec {
  name = "mpc-1.0.3";
  src = fetchurl {
    url = "mirror://gnu/mpc/${name}.tar.gz";
    sha256 = "1hzci2zrrd7v3g1jk35qindq05hbl0bhjcyyisq9z209xb3fqzb1";
  };

  propagatedBuildInputs = [ gmp mpfr ];

  enableParallelBuilding = true;
  doCheck = true;
}
