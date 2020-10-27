{ stdenv
, fetchFromGitHub
, numactl
}:

stdenv.mkDerivation rec {
  name = "libpsm2-11.2.91";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "opa-psm2";
    rev = "5b61098334d8485b06cfe0c857f67210ed3c3b69";
    sha256 = "1cx4n7rr1n79nfmf9rzv8rbxf80z26b25lx68ckbchm17splax1g";
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
