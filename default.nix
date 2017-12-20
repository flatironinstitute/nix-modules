let
  lib = import <nixpkgs/lib>;
  overlay = import ./overlay.nix;
in

import <nixpkgs> {
  # Use current platform, setting gcc.arch = "native":
  localSystem = rec {
    system = builtins.currentSystem;
    platform = lib.systems.platforms.selectBySystem system // { gcc = { arch = "native"; }; };
  };
  config = {
    allowUnfree = true;
  };
  overlays = [overlay];
}
