self: super: {
  x509-validation = super.x509-validation.overrideAttrs (old: {
    doCheck = false;
  });
}
