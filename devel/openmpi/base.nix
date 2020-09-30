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
, ucx
}:

stdenv.mkDerivation rec {
  name = "openmpi-${majorVersion}.${minorVersion}";
  passthru.tag = "openmpi${tag}";
  src = fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${majorVersion}/downloads/${name}.tar.bz2";
    inherit sha256;
  };

  nativeBuildInputs = [ perl flex ];
  buildInputs = stdenv.lib.optional java jdk ++ [ numactl rdma-core slurm zlib ucx ];
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
    cat >> $out/etc/openmpi-mca-params.conf <<EOF
oob_tcp_if_exclude = idrac,lo,ib0
btl_tcp_if_exclude = idrac,lo,ib0

btl_openib_if_exclude = i40iw0,i40iw1,mlx5_1
btl_openib_warn_nonexistent_if = 0

'' + (if stdenv.lib.versionAtLeast majorVersion "3" then ''
btl=^openib,usnix
mtl=^psm,ofi
#pml=ucx
'' else ''
btl_openib_receive_queues=P,128,2048,1024,32:S,2048,2048,1024,64:S,12288,2048,1024,64:S,65536,2048,1024,64
'') + ''
EOF
  '';
}

