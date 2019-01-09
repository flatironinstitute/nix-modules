{ stdenv
, kernelspec
, prefix ? kernelspec.language
}:

stdenv.mkDerivation rec {
  name = "jupyter-kernel-${prefix}";
  inherit prefix;
  spec = builtins.replaceStrings ["\"displayName\":"] ["\"display_name\":"] (builtins.toJSON kernelspec);
  builder = ./spec.sh;
}
