world:
self: pkgs:
with pkgs;
{
  x509-validation = x509-validation.overrideAttrs (old: {
    doCheck = false;
  });
}
