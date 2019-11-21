{ stdenv
, fetchFromGitHub
, numactl
}:

stdenv.mkDerivation rec {
  name = "libpsm2-11.2.86";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "opa-psm2";
    rev = "4f0ad8cf4d6b44fcce5f745e946a056659ba54c0";
    sha256 = "1hiqzcmc97lzhaqjva82vf8irgg038cciypsv2brw90ak09n6vwf";
  };

  buildInputs = [ numactl ];

  # Currently this requires locally-installed hfi1 headers, but could alternatively use packaged linux headers >= 4.9
  prePatch = ''
    substituteInPlace Makefile \
      --replace /usr/ /
    NIX_ENFORCE_PURITY=
  '';
  makeFlags = [
    "IFS_HFI_HEADER_PATH=/usr/include/uapi"
    "DESTDIR=$(out)"
  ];

  enableParallelBuilding = true;
}
