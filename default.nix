with import <nixpkgs> {
  stdenvStages = import <nixpkgs/pkgs/stdenv/native>;
};

rec {
  gmp = callPackage base/gmp {
  };
  mpfr = callPackage base/mpfr {
    inherit gmp;
  };
  mpc = callPackage base/mpc {
    inherit gmp;
    inherit mpfr;
  };
  gcc7 = wrapCC (callPackage devel/gcc/7.2.0.nix {
    inherit gmp;
    inherit mpfr;
    inherit mpc;
  });

  gcc7env = stdenv.override {
    cc = gcc7;
  };
}
