{
  description = "Shared Home Assistant dev/test environment for custom_components work";

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
          text = builtins.readFile ./bin/ha-dev;
          excludeShellChecks = [ "SC2155" ];
        };
      in
      {
        packages.default = ha-dev;
        devShells.default = pkgs.mkShell { packages = [ ha-dev ]; };
      }
    );
}
