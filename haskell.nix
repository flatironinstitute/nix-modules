self: super: {
  zeromq4-haskell = super.zeromq4-haskell.overrideAttrs (old: {
    doCheck = false;
  });
}
