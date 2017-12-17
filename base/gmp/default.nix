{ stdenv
, fetchurl
, m4 }:

stdenv.mkDerivation rec {
  name = "gmp-6.1.2";
  src = fetchurl {
    urls = [ "mirror://gnu/gmp/${name}.tar.bz2" "ftp://ftp.gmplib.org/pub/${name}/${name}.tar.bz2" ];
    sha256 = "1clg7pbpk6qwxj5b2mw0pghzawp2qlm3jf9gdd8i6fl6yh2bnxaj";
  };

  nativeBuildInputs = [ m4 ];

  enableParallelBuilding = true;
  doCheck = true;
}
