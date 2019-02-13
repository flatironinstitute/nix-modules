{ stdenv
, fetchFromGitHub
, ncurses
, cmake
, lsb-release
, zlib
, boost
# for docs:
, texlive
, python
}:

stdenv.mkDerivation rec {
  name = "wecall-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Genomicsplc";
    repo = "wecall";
    rev = "v${version}";
    sha256 = "0c8v6i2jyllj71pivc5s2xsld1mg3wmjg47w0f8cfi7ihc0zg5r8";
  };

  buildInputs = [ ncurses cmake lsb-release zlib boost
    texlive python ];

  postPatch = ''
    sed -i 's/-lcurses/-lncurses/' vendor/samtools/Makefile
    sed -i '/^set(CMAKE_INSTALL_PREFIX/d' cpp/CMakeLists.txt
  '';
  preBuild = ''
    make -C ../vendor
  '';
  postBuild = ''
    cp ../vendor/samtools/samtools ../vendor/tabix/tabix ../vendor/tabix/bgzip .
  '';
  cmakeDir = "../cpp";
  doCheck = true;
}
