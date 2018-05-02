let
  lib = import <nixpkgs/lib>;
in

import <nixpkgs> {
  # Use current platform, setting gcc.arch = "native":
  localSystem = rec {
    system = builtins.currentSystem;
    platform = lib.systems.platforms.selectBySystem system // { gcc = { arch = "native"; }; };
  };
  config = {
    allowUnfree = true;
    replaceStdenv = import ./stdenv.nix;
    nix = {
      storeDir = "/mnt/home/sw/nix/store";
      stateDir = "/mnt/home/sw/nix/state";
    };
  };
  overlays = [(import ./overlay.nix)];
}
