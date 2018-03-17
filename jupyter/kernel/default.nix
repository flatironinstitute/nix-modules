{ stdenv
, jq
, src
, prefix ? src.name
, note ? " (nix/${prefix})"
}:

stdenv.mkDerivation rec {
  name = "jupyter-kernel-${prefix}";
  nativeBuildInputs = [jq];
  propagatedBuildInputs = stdenv.lib.optional (builtins.isAttrs src) src;
  inherit src prefix note;
  builder = ./builder.sh;
}
