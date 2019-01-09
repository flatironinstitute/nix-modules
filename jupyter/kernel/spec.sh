source $stdenv/setup

mkdir -p $out/share/jupyter/kernels/$prefix
echo "$spec" > $out/share/jupyter/kernels/$prefix/kernel.json
