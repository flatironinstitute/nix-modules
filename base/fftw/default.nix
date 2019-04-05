{ stdenv
, fetchurl
, precision ? "double"
, mpi ? null
}:

assert stdenv.lib.elem precision [ "single" "double" "long-double" "quad-precision" ];

let
  version = "3.3.8";
in

stdenv.mkDerivation rec {
  name = "fftw-${precision}-${version}";

  src = fetchurl {
    url = "ftp://ftp.fftw.org/pub/fftw/fftw-${version}.tar.gz";
    sha256 = "00z3k8fq561wq2khssqg0kallk0504dzlx989x3vvicjdqpjc4v1";
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
