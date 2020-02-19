{ tag
, majorVersion
, minorVersion
, sha256
}:

{ stdenv
, fetchurl
, perl
, flex
, java ? false, jdk ? null
, numactl
, libpsm2
, slurm
, rdma-core
, zlib
}:

stdenv.mkDerivation rec {
  name = "openmpi-${majorVersion}.${minorVersion}";
  passthru.tag = "openmpi${tag}";
  src = fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${majorVersion}/downloads/${name}.tar.bz2";
    inherit sha256;
  };

  nativeBuildInputs = [ perl flex ];
  buildInputs = stdenv.lib.optional java jdk ++ [ numactl rdma-core slurm zlib ];
  propagatedBuildInputs = [ libpsm2 stdenv.cc ];

  configureFlags = [
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

