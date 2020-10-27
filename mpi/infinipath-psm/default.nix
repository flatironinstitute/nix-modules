{ stdenv
, fetchFromGitHub
, libuuid
}:

stdenv.mkDerivation rec {
  name = "infinipath-psm-3.3.26";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "psm";
    rev = "604758e76dc31e68d1de736ccf5ddf16cb22355b";
    sha256 = "0nsb325dmhn5ia3d2cnksqr0gdvrrx2hmvlylfgvmaqdpq76zm85";
  };

  buildInputs = [ libuuid ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace /usr/include/uuid '$(libuuid)/include/uuid' \
      --replace /usr/include/psm '\$(LOCAL_PREFIX)/include/psm'
  '';
  makeFlags = [
    "arch=${stdenv.targetPlatform.parsed.cpu.name}"
    "WERROR="
    "DESTDIR=$(out)"
    "LOCAL_PREFIX=/"
  ];

  enableParallelBuilding = true;
}
