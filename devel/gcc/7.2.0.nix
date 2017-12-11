{ stdenv
, fetchurl
, texinfo
, gmp
, mpfr
, mpc
}:

stdenv.mkDerivation rec {
  name = "gcc-7.2.0";
  src = fetchurl {
    url = "mirror://gcc/releases/${name}/${name}.tar.xz";
    sha256 = "16j7i0888j2f1yp9l0nhji6cq65dy6y4nwy8868a8njbzzwavxqw";
  };

  passthru = {
    isGNU = true;
  };
  nativeBuildInputs = [ texinfo ];
  buildInputs = [ gmp mpfr mpc ];

  configureFlags = [
    "--enable-languages=c,c++,fortran,objc,obj-c++"
    "--enable-shared"
    "--disable-nls"
    "--disable-multilib"
    "--with-arch=native"
    "--with-tune=native"
    "--with-gmp=${gmp}"
    "--with-mpfr=${mpfr}"
    "--with-mpc=${mpc}"
  ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;
  doCheck = false;
}
