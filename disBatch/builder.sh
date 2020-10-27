. $stdenv/setup

mkdir -p $out/{lib,bin}
cp -a $src $out/lib/disBatch
chmod 755 $out/lib/disBatch $out/lib/disBatch/disBatch.py
$out/lib/disBatch/disBatch.py --fix-paths
ln -s ../lib/disBatch/disBatch.py $out/bin
ln -s disBatch.py $out/bin/disBatch
