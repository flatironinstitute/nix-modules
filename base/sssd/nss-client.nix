{ stdenv
, fetchurl
, pkgconfig
, glibc, pam, openldap, kerberos, dnsutils, cyrus_sasl, nss
, popt, talloc, tdb, tevent, ldb, ding-libs, pcre, c-ares
, glib, dbus
}:

let
  version = "1.15.3";
in

stdenv.mkDerivation rec {
  name = "sssd-nss-client-${version}";

  src = fetchurl {
    urls = [ "https://releases.pagure.org/SSSD/sssd/sssd-${version}.tar.gz" "https://fedorahosted.org/released/sssd/sssd-${version}.tar.gz" ];
    sha256 = "0d36dmzqdjfpspm9fw4zx0kh0qcx60p9vchxvcajn4qf3k3qsl3f";
  };

  # libnss_sss.so does not in fact use any of these -- they're just needed for configure
  nativeBuildInputs = [ pkgconfig
    pam openldap kerberos dnsutils cyrus_sasl nss
    popt talloc tdb tevent ldb ding-libs pcre c-ares
    glib dbus
  ];

  configureFlags = [
    # connect and use to system sssd:
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-os=redhat"

    "--with-nscd=${glibc.bin}/sbin/nscd"
    "--with-ldb-lib-dir=$(out)/modules/ldb"
    "--disable-cifs-idmap-plugin"
    "--without-autofs"
    "--without-kcm"
    "--without-libnl"
    "--without-libwbclient"
    "--without-manpages"
    "--without-nfsv4-idmapd-plugin"
    "--without-python2-bindings"
    "--without-python3-bindings"
    "--without-samba"
    "--without-secrets"
    "--without-selinux"
    "--without-semanage"
    "--without-ssh"
    "--without-sudo"
  ];

  enableParallelBuilding = true;

  buildFlags = [ "libnss_sss.la" ];
  installTargets = [ "install-nsslibLTLIBRARIES" ];

}
