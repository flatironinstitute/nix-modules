let nixpkgs = import <nixpkgs> {
  #stdenvStages = import <nixpkgs/pkgs/stdenv/native>;
}; in

rec {
  gmp = nixpkgs.callPackage ./base/gmp { };
  mpfr = nixpkgs.callPackage ./base/mpfr {
    inherit gmp;
  };
  mpc = nixpkgs.callPackage ./base/mpc {
    inherit gmp;
    inherit mpfr;
  };
}
