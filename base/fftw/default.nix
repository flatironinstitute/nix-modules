{ stdenv
, fetchurl
, precision ? "double"
, mpi ? null
}:

assert stdenv.lib.elem precision [ "single" "double" "long-double" "quad-precision" ];

let
  version = "3.3.7";
  mpitag = stdenv.lib.optionalString (mpi != null) "-${mpi.tag}";
in

stdenv.mkDerivation rec {
  name = "fftw${mpitag}-${precision}-${version}";

  src = fetchurl {
    url = "ftp://ftp.fftw.org/pub/fftw/fftw-${version}.tar.gz";
    sha256 = "0wsms8narnbhfsa8chdflv2j9hzspvflblnqdn7hw8x5xdzrnq1v";
  };

  buildInputs = [ mpi ];

  configureFlags =
    [ "--enable-shared"
      "--enable-threads"
    ]
    ++ stdenv.lib.optional (precision != "double") "--enable-${precision}"
    ++ stdenv.lib.optional (precision == "single") "--enable-sse"
    ++ stdenv.lib.optional (precision == "single" || precision == "double") "--enable-sse2 --enable-avx --enable-avx2 --enable-fma"
    ++ stdenv.lib.optional (mpi != null) "--enable-mpi";

  enableParallelBuilding = true;
}
