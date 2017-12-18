let
  # Try to use native tools to bootstrap (broken):
  nativeTools = false;

  lib = import <nixpkgs/lib>;
  pkgs = import <nixpkgs> {
    # Use current platform, setting gcc.arch = "native":
    localSystem = rec {
      system = builtins.currentSystem;
      platform = lib.systems.platforms.selectBySystem system // { gcc = { arch = "native"; }; };
    };
    overlays = [];
    stdenvStages = import (if nativeTools then <nixpkgs/pkgs/stdenv/native> else <nixpkgs/pkgs/stdenv>);
  };

  local = self: rec {
    # gcc bootstrap packages for native only
    gmp = pkgs.callPackage base/gmp { };
    mpfr = pkgs.callPackage base/mpfr {
      inherit gmp;
    };
    mpc = pkgs.callPackage base/mpc {
      inherit gmp mpfr;
    };

    gcc6 = pkgs.wrapCC (if nativeTools
      then pkgs.callPackage devel/gcc/6.4.0.nix {
	inherit gmp mpfr mpc;
      }
      else pkgs.gcc6.cc.override {
	langC = true;
	langCC = true;
	langFortran = true;
	langObjC = true;
	langObjCpp = true;
	enableShared = true;
	enableMultilib = false;
      });

    gcc7 = pkgs.wrapCC (if nativeTools
      then pkgs.callPackage devel/gcc/7.2.0.nix {
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

    # define new local environment:
    gcc = gcc6;
    gfortran = gcc;
    stdenv = pkgs.overrideCC pkgs.stdenv gcc;
    callPackage = pkgs.newScope self;

    # intel infiniband/psm stuff
    infinipath-psm = callPackage base/infinipath-psm { };
    libpsm2 = callPackage base/libpsm2 { };
    rdma-core = callPackage base/rdma-core { };

    openmpi = callPackage devel/openmpi/1.10.7.nix { };
    openmpi2 = callPackage devel/openmpi/2.1.2.nix { };

    fftw = callPackage base/fftw/precs.nix { };
    fftw-openmpi1 = callPackage base/fftw/precs.nix {
      mpi = openmpi;
    };
    fftw-openmpi2 = callPackage base/fftw/precs.nix {
      mpi = openmpi2;
    };

    openblas = callPackage base/openblas {
    };

    hdf5 = pkgs.hdf5.override {
      cpp = true;
    };

    python2 = pkgs.python2.override {
      ucsEncoding = 4;
    };
  };
in pkgs // lib.fix local
