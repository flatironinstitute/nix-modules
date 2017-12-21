stdenv:

let
  module = import ./. stdenv;
in

pkgs:

stdenv.mkDerivation {
  builder = ./modules.sh;

  name = "modules";

  buildInputs = map module pkgs;
}
