{ stdenv
, lib
, fetchurl
, mpi ? null
}:

lib.genAttrs
  (["single" "double" "long-double"] ++ lib.optional (mpi == null) "quad-precision")
  (precision: import ./. { inherit stdenv lib fetchurl mpi precision; })
