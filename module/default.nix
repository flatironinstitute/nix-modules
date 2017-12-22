{ stdenv
, pkg
, pkgName ? builtins.replaceStrings ["-wrapper" "-all"] ["" ""] (builtins.parseDrvName pkg.name).name
, pkgVersion ? (builtins.parseDrvName pkg.name).version
, modPrefix ? "nix/"
, modName ? "${modPrefix}${pkgName}/${pkgVersion}"
, modLoad ? []
, modPrereq ? []
, modConflict ? [pkgName] ++ stdenv.lib.optional (modPrefix != "") (modPrefix + pkgName)
, addPath ? true
, addLDLibraryPath ? false
, addPkgConfigPath ? true
, addManPath ? true
, addCCFlags ? true
}:

stdenv.mkDerivation {
  builder = ./builder.sh;

  name = "module-${pkg.name}";

  buildInputs = [ pkg ];

  inherit pkgName pkgVersion modPrefix modName modLoad modPrereq modConflict addPath addLDLibraryPath addPkgConfigPath addManPath addCCFlags;

  # sort of hacky, duplicating cc-wrapper:
  nixInfix = stdenv.lib.replaceStrings ["-"] ["_"] stdenv.targetPlatform.config;

  passthru = {
    inherit pkg modName;
  };
}
