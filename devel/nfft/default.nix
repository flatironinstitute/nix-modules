{ stdenv
, fetchurl
, fftw
, cunit
, ncurses
}:

stdenv.mkDerivation rec {
  name = "nfft-3.4.0";

  src = fetchurl {
    url = "https://www-user.tu-chemnitz.de/~potts/nfft/download/${name}.tar.gz";
    sha256 = "14cr9jn0mv67xliybmcbvaqz7pddslq08ciijfwjigklhra5haf6";
  };

  propagatedBuildInputs = [ fftw ];

  # needed for testing:
  nativeBuildInputs = [ cunit ncurses ];

  configureFlags = [
    "--enable-all"
    "--enable-openmp"
  ];

  enableParallelBuilding = true;

  doCheck = true;
}
