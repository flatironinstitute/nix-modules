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
  name = "rdma-core-16";
  src = fetchFromGitHub {
    owner = "linux-rdma";
    repo = "rdma-core";
    rev = "v16";
    sha256 = "131gckfnb0flcyy27nc6kjpk17cmadjwv7rpsg1g0lbrx83b7irl";
  };

  nativeBuildInputs = [ cmake ninja pkgconfig python ];
  buildInputs = [ libnl libudev ];
  # would also like newer linux headers including rdma/rdma_netlink.h

  enableParallelBuilding = true;
}
