{ stdenv
}:

stdenv.mkDerivation rec {
  name = "module-wrap";
  src = ./wrap.sh;
  builder = ./builder.sh;
}
