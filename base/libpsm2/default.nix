{ stdenv
, fetchFromGitHub
, numactl
}:

stdenv.mkDerivation rec {
  name = "libpsm2-10.3.37";
  src = fetchFromGitHub {
    owner = "01org";
    repo = "opa-psm2";
    rev = "01d12825369bfc8d9d20729b2df828921e77c516";
    sha256 = "0g3k4mi3c5v5gf731r4gb1w9avfk5wz42i4wrwycg28ac31hg7m7";
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
