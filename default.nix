let
  lib = import <nixpkgs/lib>;
in

import <nixpkgs> {
  # Use current platform, setting gcc.arch = "broadwell":
  localSystem = rec {
    system = builtins.currentSystem;
    platform = lib.systems.platforms.selectBySystem system // { gcc.arch = "broadwell"; };
  };
  config = {
    allowUnfree = true;
    replaceStdenv = import ./stdenv.nix;
    nix = {
      storeDir = "/cm/shared/sw/nix/store";
      stateDir = "/cm/shared/sw/nix/state";
    };
    cudaSupport = true;
  };
  overlays = [(import ./overlay.nix)];
}
