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

let majorVersion = "4.0"; in

stdenv.mkDerivation rec {
  name = "openmpi-${majorVersion}.1";
  passthru.tag = "openmpi4";
  src = fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${majorVersion}/downloads/${name}.tar.bz2";
    sha256 = "02cpzcp113gj5hb0j2xc0cqma2fn04i2i0bzf80r71120p9bdryc";
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
    rm -f $out/lib/*.la
    echo 'oob_tcp_if_exclude = idrac,lo,ib0' >> $out/etc/openmpi-mca-params.conf
    echo 'btl_tcp_if_exclude = idrac,lo,ib0' >> $out/etc/openmpi-mca-params.conf
  '';
}

