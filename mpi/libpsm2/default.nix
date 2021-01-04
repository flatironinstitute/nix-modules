{ stdenv
, fetchFromGitHub
, numactl
}:

stdenv.mkDerivation rec {
  name = "libpsm2-11.2.185";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "opa-psm2";
    rev = "7a33bedc4bb3dff4e57c00293a2d70890db4d983";
    sha256 = "062hg4r6gz7pla9df70nqs5i2a3mp1wszmp4l0g771fykhhrxsjg";
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
