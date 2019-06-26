world:
self: pkgs:
with pkgs;
{
  hlint = world.haskell.lib.overrideCabal hlint (old: {
    version = "2.1.17";
    sha256 = "0brinb3fjy619qh8yingqz2k03gcixc7mvqxzhzjadj69zlns6j3";
    libraryHaskellDepends = [
      aeson ansi-terminal base bytestring cmdargs containers cpphs
      data-default directory extra filepath
      haskell-src-exts haskell-src-exts-util hscolour process refact text
      transformers uniplate unordered-containers vector yaml
    ];
  });
}
