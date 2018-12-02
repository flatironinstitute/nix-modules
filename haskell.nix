self: super: {
  cryptonite = super.cryptonite.overrideAttrs (old: {
    doCheck = false;
  });
  x509-validation = super.x509-validation.overrideAttrs (old: {
    doCheck = false;
  });
  zeromq4-haskell = super.zeromq4-haskell.overrideAttrs (old: {
    doCheck = false;
  });
}
