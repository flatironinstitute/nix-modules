{ stdenv
, fetchurl
, fftw
, cunit
, ncurses
}:

stdenv.mkDerivation rec {
  name = "nfft-3.5.1";

  src = fetchurl {
    url = "https://www-user.tu-chemnitz.de/~potts/nfft/download/${name}.tar.gz";
    sha256 = "1qzyfsbr10wqslgxdq9vifsaiszgm18hfx10pga75nf6831b55dv";
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
