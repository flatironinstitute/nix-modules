let
  nativeTools = false;
  lib = import <nixpkgs/lib>;
  nativePlatform = (import <nixpkgs/lib/systems/platforms.nix> { inherit lib; }).selectBySystem
    builtins.currentSystem // {
      gcc = { arch = "native"; };
    };
  config = {
    platform = nativePlatform;
  };
  overlays = [];
  pkgs = import <nixpkgs> {
    inherit config overlays;
    stdenvStages = import (if nativeTools then <nixpkgs/pkgs/stdenv/native> else <nixpkgs/pkgs/stdenv>);
  };
in

with pkgs;

pkgs // rec {
  gmp = callPackage base/gmp {
  };
  mpfr = callPackage base/mpfr {
    inherit gmp;
  };
  mpc = callPackage base/mpc {
    inherit gmp mpfr;
  };
  gcc7 = wrapCC (if nativeTools
    then callPackage devel/gcc/7.2.0.nix {
      inherit gmp mpfr mpc;
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

  stdenv = overrideCC pkgs.stdenv gcc7;

  infinipath-psm = callPackage base/infinipath-psm {
    inherit stdenv;
  };

  libpsm2 = callPackage base/libpsm2 {
    inherit stdenv;
  };

  rdma-core = callPackage base/rdma-core {
    inherit stdenv;
  };

  openmpi = callPackage devel/openmpi/1.10.7.nix {
    inherit stdenv infinipath-psm libpsm2 rdma-core;
  };

  openmpi2 = callPackage devel/openmpi/2.1.2.nix {
    inherit stdenv infinipath-psm libpsm2 rdma-core;
  };
}
