{ stdenv
, fetchurl
, gmp
}:

stdenv.mkDerivation rec {
  name = "mpfr-3.1.6";
  src = fetchurl {
    url = "mirror://gnu/mpfr/${name}.tar.xz";
    sha256 = "0l598h9klpgkz2bp0rxiqb90mkqh9f2f81n5rpy191j00hdaqqks";
  };

  propagatedBuildInputs = [ gmp ];

  enableParallelBuilding = true;
  doCheck = true;
}
