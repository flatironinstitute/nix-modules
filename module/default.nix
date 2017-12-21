stdenv: pkg:

let
  parse = builtins.parseDrvName pkg.name;
in

stdenv.mkDerivation {
  builder = ./builder.sh;

  name = "module-${pkg.name}";

  buildInputs = [ pkg ];
  parseName = builtins.replaceStrings ["-wrapper" "-all"] ["" ""] parse.name;
  parseVersion = parse.version;

  passthru = {
    inherit pkg;
  };
}
