{ stdenv
, fetchurl
, mpi
}:

stdenv.mkDerivation rec {
  name = "osu-micro-benchmarks-5.6.3";
  src = fetchurl {
    url = "http://mvapich.cse.ohio-state.edu/download/mvapich/${name}.tar.gz";
    sha256 = "1f5fc252c0k4rd26xh1v5017wfbbsr2w7jm49x8yigc6n32sisn5";
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
