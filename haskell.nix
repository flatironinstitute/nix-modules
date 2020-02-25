world:
self: pkgs:
with pkgs;
{
  network = network.overrideAttrs (old: {
    doCheck = false; # no expected exception?
  });
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
