{ stdenv
, fetchurl
, fftw
, cunit
, ncurses
}:

stdenv.mkDerivation rec {
  name = "nfft-3.5.0";

  src = fetchurl {
    url = "https://www-user.tu-chemnitz.de/~potts/nfft/download/${name}.tar.gz";
    sha256 = "01vab2l0kimxaxvnjl6xl42rw12gnpqvv5jwwnnfgbkmlv9ajy2z";
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
