{ stdenv
, lib
, fetchurl
, mpi ? null
, buildEnv
}:

let
  precs = lib.genAttrs
    (["single" "double" "long-double"] ++ lib.optional (mpi == null) "quad-precision")
    (precision: import ./. { inherit stdenv lib fetchurl mpi precision; });
  all = buildEnv {
    name = builtins.replaceStrings ["single"] ["all"] precs.single.name;
    paths = builtins.attrValues precs;
    passthru = precs;
  };
in

all // { dev = all.out; }
