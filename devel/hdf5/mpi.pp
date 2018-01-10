{ callPackage
, mpi ? null
}:

(callPackage <nixpkgs/pkgs/tools/misc/hdf5> {
  szip = null;
  inherit mpi;
}).overrideDerivation (old: {
  name = if mpi != null then "hdf5-${mpi.tag}-${old.version}" else old.name;
})
