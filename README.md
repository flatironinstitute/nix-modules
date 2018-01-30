This is a nixpkgs overlay with various additional cluster packages.

It includes the ability to create a Modules modulefile version of each package, rather than using `nix-env` as usual.

`env` sets up the environment for the local cluster and points to the nix install.

Individual packages can be built with `nix-build -A PKGNAME .`.

The `update` script builds a full set of modules and updates the system modules profile with the result.
