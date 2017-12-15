let
  nativeTools = false;
  lib = import <nixpkgs/lib>;
  nativePlatform = (import <nixpkgs/lib/systems/platforms.nix> { inherit lib; }).selectBySystem builtins.currentSystem // {
    gcc = { arch = "native"; };
  };
  config = {
    platform = nativePlatform;
  };
  pkgs = import <nixpkgs> {
    inherit config;
    stdenvStages = import (if nativeTools then <nixpkgs/pkgs/stdenv/native> else <nixpkgs/pkgs/stdenv>);
  };
in

with pkgs;

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
  gcc7 = wrapCC (if nativeTools
    then callPackage devel/gcc/7.2.0.nix {
      inherit gmp;
      inherit mpfr;
      inherit mpc;
    }
    else pkgs.gcc7.cc.override {
      langC = true;
      langCC = true;
      langFortran = true;
      langObjC = true;
      langObjCpp = true;
      enableShared = true;
      enableMultilib = false;
    });

  gcc7env = overrideCC stdenv gcc7;

  };
}
