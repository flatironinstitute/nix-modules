{ stdenv
, fetchurl
, mpi
}:

stdenv.mkDerivation rec {
  name = "osu-micro-benchmarks-5.4";
  src = fetchurl {
    url = "http://mvapich.cse.ohio-state.edu/download/mvapich/${name}.tar.gz";
    sha256 = "0cwg58gzp3jnwmf5bzbn1yvjdy70bkl8bbarkfjhawm02cp7djp1";
  };

  nativeBuildInputs = [ mpi ];

  configureFlags = [
    "CC=${mpi}/bin/mpicc"
    "CXX=${mpi}/bin/mpicxx"
  ];

  enableParallelBuilding = true;
  doCheck = true;

  postInstall = ''
    mkdir $out/bin
    ln -s $out/libexec/osu-micro-benchmarks/mpi/*/* $out/bin
  '';
}
