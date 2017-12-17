{ stdenv
, fetchFromGitHub
, perl
, which
}:

let
  version = "0.2.20";
in

stdenv.mkDerivation {
  name = "openblas-${version}";
  src = fetchFromGitHub {
    owner = "xianyi";
    repo = "OpenBLAS";
    rev = "v${version}";
    sha256 = "0kdzigm0b40vkw5prlvixzb9m8zm0z4967dnhrl2wqwl2y3y1h2c";
  };

  # Some hardening features are disabled due to sporadic failures in
  # OpenBLAS-based programs. The problem may not be with OpenBLAS itself, but
  # with how these flags interact with hardening measures used downstream.
  # In either case, OpenBLAS must only be used by trusted code--it is
  # inherently unsuitable for security-conscious applications--so there should
  # be no objection to disabling these hardening measures.
  hardeningDisable = [
    # don't modify or move the stack
    "stackprotector" "pic"
    # don't alter index arithmetic
    "strictoverflow"
    # don't interfere with dynamic target detection
    "relro" "bindnow"
  ];

  nativeBuildInputs = [perl which];

  patches = [ ./patch ];
  makeFlags = [
    ''PREFIX="''$(out)"''
  ];

  doCheck = true;
  checkTarget = "tests";
}
