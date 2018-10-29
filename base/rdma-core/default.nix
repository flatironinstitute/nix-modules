{ stdenv
, fetchFromGitHub
, cmake
, ninja
, pkgconfig
, libnl
, libudev
, python
}:

stdenv.mkDerivation rec {
  name = "rdma-core-16.6";
  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v16.6";
    sha256 = "07w6b42j4qmikdpw2cmz6n4bm7ffwzq1h75ls664c2241q1lx92j";
  };

  nativeBuildInputs = [ cmake ninja pkgconfig python ];
  buildInputs = [ libnl libudev ];
  # would also like newer linux headers including rdma/rdma_netlink.h

  enableParallelBuilding = true;
}
