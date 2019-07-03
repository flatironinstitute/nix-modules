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
  name = "mvapich2-2.3.1";
  passthru.tag = "mvapich2";
  src = fetchurl {
    url = "http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/${name}.tar.gz";
    sha256 = "1gz31q70iim79q13sfjlqsm8f5rdaxrajya7rn1yvwvmky114kii";
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
