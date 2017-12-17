{ stdenv
, lib
, fetchurl
, precision ? "double"
, mpi ? null
}:

assert lib.elem precision [ "single" "double" "long-double" "quad-precision" ];

let
  version = "3.3.7";
in

stdenv.mkDerivation rec {
  name = "fftw-${precision}-${version}";

  src = fetchurl {
    url = "ftp://ftp.fftw.org/pub/fftw/fftw-${version}.tar.gz";
    sha256 = "0wsms8narnbhfsa8chdflv2j9hzspvflblnqdn7hw8x5xdzrnq1v";
  };

  buildInputs = [ mpi ];

  configureFlags =
    [ "--enable-shared"
      "--enable-threads"
    ]
    ++ lib.optional (precision != "double") "--enable-${precision}"
    ++ lib.optional (precision == "single") "--enable-sse"
    ++ lib.optional (precision == "single" || precision == "double") "--enable-sse2 --enable-avx --enable-avx2 --enable-fma"
    ++ lib.optional (mpi != null) "--enable-mpi";

  enableParallelBuilding = true;
}
