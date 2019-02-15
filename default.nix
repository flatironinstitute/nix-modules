let
  lib = import <nixpkgs/lib>;
in

import <nixpkgs> {
  # Use current platform, setting gcc.arch = "broadwell":
  localSystem = rec {
    system = builtins.currentSystem;
    platform = lib.systems.platforms.selectBySystem system // { gcc = { arch = "sandybridge"; }; };
  };
  config = {
    allowUnfree = true;
    replaceStdenv = import ./stdenv.nix;
    nix = {
      storeDir = "/simons/scratch/dylan/nix/store";
      stateDir = "/simons/scratch/dylan/nix/state";
    };
    cudaSupport = true;
    haskellPackageOverrides = import ./haskell.nix;
  };
  overlays = [(import ./overlay.nix)];
}
