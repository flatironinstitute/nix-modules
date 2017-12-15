{ stdenv
, fetchurl
, perl
, numactl
, infinipath-psm
}:

let majorVersion = "1.10"; in

stdenv.mkDerivation rec {
  name = "openmpi-${majorVersion}.7";
  src = fetchurl {
    url = "http://www.open-mpi.org/software/ompi/v${majorVersion}/downloads/${name}.tar.bz2";
    sha256 = "142s1vny9gllkq336yafxayjgcirj2jv0ddabj879jgya7hyr2d0";
  };

  nativeBuildInputs = [ perl ];
  buildInputs = [ numactl ];
  propagatedBuildInputs = [ infinipath-psm ];

  configureFlags = [
    "--with-pmi=/cm/shared/apps/slurm/17.02.2"
    #"--with-psm2=/usr"
  ];

  enableParallelBuilding = true;
  doCheck = true;
}
