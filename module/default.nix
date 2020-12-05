{ stdenv
, buildEnv
, pkg
, pkgTag ? if pkg.mpi or null != null then pkg.mpi.tag else null
, pkgName ? pkg.tag or (builtins.replaceStrings ["-wrapper" "-all"] ["" ""]
    (builtins.parseDrvName pkg.name).name)
  + (if pkgTag != null then "-${pkgTag}" else "")
, pkgVersion ? builtins.replaceStrings ["_"] ["."]
    (builtins.parseDrvName pkg.name).version
, modPrefix ? "nix/"
, modSuffix ? ""
, modName ? "${modPrefix}${pkgName}/${pkgVersion}${modSuffix}"
, modLoad ? []
, modPrereq ? if pkgTag != null then [(modPrefix + pkgTag)] else []
, modConflict ? [pkgName ("lib/" + pkgName)] ++ stdenv.lib.optional (modPrefix != "") (modPrefix + pkgName)
, modEnvPrefix ? builtins.replaceStrings ["-"] ["_"] (stdenv.lib.toUpper pkgName)
, modDescr ? ""
, setEnv ? []
, addLDLibraryPath ? false
, addCFlags ? true
, glibcLocales
, addLocales ? glibcLocales
, addOpenGLDrivers ? false
}:

let monopkg = if builtins.length pkg.outputs > 1
  then buildEnv {
    name = pkg.name;
    paths = map (out: pkg.${out}) pkg.outputs;
  } else pkg;
in

stdenv.mkDerivation {
  builder = ./builder.sh;

  name = "module-${pkgName}-${pkgVersion}";

  buildInputs = if pkg != null then [monopkg] else [];

  inherit pkgName pkgVersion modPrefix modName modLoad modPrereq modConflict modEnvPrefix addLDLibraryPath addCFlags addLocales addOpenGLDrivers setEnv modDescr;

  # sort of hacky, duplicating cc-wrapper:
  nixSuffix = stdenv.lib.replaceStrings ["-"] ["_"] stdenv.targetPlatform.config;

  passthru = {
    inherit pkg modName;
  };
}
