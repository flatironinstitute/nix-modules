{ stdenv
, jupyter
, env
, prefix ? env.name
, note ? " (nix/${prefix})"
}:

stdenv.mkDerivation rec {
  name = "jupyter-kernel-juniper-${prefix}";
  nativeBuildInputs = [jupyter];
  propagatedBuildInputs = stdenv.lib.optional (builtins.isAttrs env) env;
  inherit env prefix note;
  rBuilder = ./builder.R;
  builder = ./builder.sh;
}
