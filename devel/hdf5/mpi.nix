{ stdenv
, callPackage
, hdf5 ? <nixpkg/pkgs/tools/misc/hdf5>
, fetchurl
, removeReferencesTo
, cpp ? false
, gfortran ? null
, fortran2003 ? false
, zlib ? null
, szip ? null
, mpi ? null
, enableShared ? true
}:

(callPackage hdf5 {
  szip = null;
  inherit mpi;
}).overrideDerivation (old: {
  name = if mpi != null then "hdf5-${mpi.tag}-${old.version}" else old.name;
})
