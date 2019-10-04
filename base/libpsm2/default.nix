{ stdenv
, fetchFromGitHub
, numactl
}:

stdenv.mkDerivation rec {
  name = "libpsm2-10.3.37";
  src = fetchFromGitHub {
    owner = "01org";
    repo = "opa-psm2";
    rev = "816c0dbdf911dba097dcbb09f023c5113713c33e";
    sha256 = "0vkw5g1p3pfr58a2g7a4mk247jg07jawx9iwkikwyqgnrsrkcqg1";
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
