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

let majorVersion = "2.1"; in

stdenv.mkDerivation rec {
  name = "openmpi-${majorVersion}.2";
  src = fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${majorVersion}/downloads/${name}.tar.bz2";
    sha256 = "0dfnilbh5nnyp08h0vi5kfi49lhyjzr49z7gi3grncn5hi4q1i9w";
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
