{ stdenv
, fetchurl
, mpi ? null
, buildEnv
}:

let
  precs = stdenv.lib.genAttrs
    (["single" "double" "long-double"] ++ stdenv.lib.optional (mpi == null) "quad-precision")
    (precision: import ./. { inherit stdenv fetchurl mpi precision; });
  all = buildEnv {
    name = builtins.replaceStrings ["single"] ["all"] precs.single.name;
    paths = builtins.attrValues precs;
    passthru = precs;
  };
in

all // { dev = all.out; }
