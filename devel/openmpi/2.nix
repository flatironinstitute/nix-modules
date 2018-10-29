{ stdenv
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
  name = "openmpi-${majorVersion}.5";
  passthru.tag = "openmpi2";
  src = fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${majorVersion}/downloads/${name}.tar.bz2";
    sha256 = "153pgsc8xr6fqkwik2b4j8viscyk3h2jkpsyk8aw69qzh2mwq1xq";
  };

  nativeBuildInputs = [ perl flex ];
  buildInputs = stdenv.lib.optional java jdk ++ [ numactl rdma-core slurm ];
  propagatedBuildInputs = [ infinipath-psm libpsm2 stdenv.cc ];

  configureFlags = [
    "--with-psm=${infinipath-psm}"
    "--with-psm2=${libpsm2}"
    "--with-pmi=${slurm.dev}"
    "--with-pmi-libdir=${slurm}/lib"
  ];

  enableParallelBuilding = true;
  doCheck = true;

  postInstall = ''
    echo 'oob_tcp_if_exclude = idrac,lo' >> $out/etc/openmpi-mca-params.conf
    echo 'btl_tcp_if_exclude = idrac,lo' >> $out/etc/openmpi-mca-params.conf
  '';
}
