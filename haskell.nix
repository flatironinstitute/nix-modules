world:
self: pkgs:
with pkgs;
{
  tls = tls.overrideAttrs (old: {
    doCheck = false; # too many pending signals
  });
  x509 = x509.overrideAttrs (old: {
    doCheck = false; # too many pending signals
  });
  x509-validation = x509-validation.overrideAttrs (old: {
    doCheck = false;
  });
}
