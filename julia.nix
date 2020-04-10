{ stdenv
, julia
, makeWrapper
, cacert
, git
, pkgconfig
, which
, curl
}:

stdenv.mkDerivation rec {
  name = julia.name + "-env";
  version = julia.version;
  nativeBuildInputs = [ makeWrapper cacert git pkgconfig which curl ];
  buildInputs = [ julia ];
  phases = [ "installPhase" ];
  installPhase = ''
    JULIA_DEPOT_PATH=$out/depot XDG_DATA_HOME=$out/share julia -e 'using Pkg; Pkg.add("IJulia")'
    makeWrapper ${julia}/bin/julia $out/bin/julia \
        --suffix JULIA_DEPOT_PATH "" ":$out/depot"
    sed -i "s!${julia}/bin/julia!$out/bin/julia!" $out/share/jupyter/kernels/*/kernel.json
  '';
}
