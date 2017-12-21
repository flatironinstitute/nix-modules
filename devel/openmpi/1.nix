{ stdenv, lib
, fetchurl
, perl
, flex
, java ? false, jdk ? null
, numactl
, infinipath-psm
, libpsm2
, slurm
, rdma-core
}:

let majorVersion = "1.10"; in

stdenv.mkDerivation rec {
  name = "openmpi-${majorVersion}.7";
  passthru.tag = "openmpi1";
  src = fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${majorVersion}/downloads/${name}.tar.bz2";
    sha256 = "142s1vny9gllkq336yafxayjgcirj2jv0ddabj879jgya7hyr2d0";
  };

  nativeBuildInputs = [ perl flex ];
  buildInputs = lib.optional java jdk ++ [ numactl rdma-core ];
  propagatedBuildInputs = [ infinipath-psm libpsm2 stdenv.cc ];

  configureFlags = [
    "--with-psm=${infinipath-psm}"
    "--with-psm2=${libpsm2}"
    "--with-pmi=${slurm.dev}"
    "--with-pmi-libdir=${slurm}"
  ];

  enableParallelBuilding = true;
  doCheck = true;
}
