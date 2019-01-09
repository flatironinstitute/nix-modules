{ stdenv
, fetchurl
, perl
, infinipath-psm
, libpsm2
, slurm
, libibverbs
, libibmad
, rdma-core
}:

stdenv.mkDerivation rec {
  name = "mvapich2-2.2";
  passthru.tag = "mvapich2";
  src = fetchurl {
    url = "http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/${name}.tar.gz";
    sha256 = "0cdi7cxmkfl1zhi0czmzm0mvh98vbgq8nn9y1d1kprixnb16y6kr";
  };

  buildInputs = [ perl slurm infinipath-psm libpsm2 libibverbs libibmad rdma-core ];

  configureFlags = [
    "--with-psm-include=${infinipath-psm}"
    "--with-psm-lib=${infinipath-psm}"
    "--with-psm2-include=${libpsm2}"
    "--with-psm2-lib=${libpsm2}"
    "--with-slurm-include=${slurm.dev}"
    "--with-slurm-lib=${slurm}"
    "--with-ibverbs-include=${libibverbs}"
    "--with-ibverbs-lib=${libibverbs}"
    "--with-pm=slurm"
  ];

  enableParallelBuilding = true;
  doCheck = true;
}
