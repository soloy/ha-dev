{
  description = "Shared Home Assistant dev/test environment for custom_components work";
  # SPDX-License-Identifier: MIT

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        ha-dev = pkgs.writeShellApplication {
          name = "ha-dev";
          runtimeInputs = [ pkgs.python313 ];
          # BASELINE pinned to this package's own copy of ./baseline (in the
          # Nix store), overriding the script's bash-source-relative fallback
          # that's only there for running bin/ha-dev directly, unpackaged.
          text = ''
            BASELINE="${./baseline}"
          ''
          + builtins.readFile ./bin/ha-dev;
          excludeShellChecks = [ "SC2155" ];
        };
      in
      {
        packages.default = ha-dev;
        devShells.default = pkgs.mkShell { packages = [ ha-dev ]; };
      }
    );
}
