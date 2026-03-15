{ inputs, lib, ... }:
let
  nixos-anywhere-platforms = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];
in
{
  flake.apps = lib.genAttrs nixos-anywhere-platforms (system: {
    nixos-anywhere = {
      type = "app";
      program = lib.getExe inputs.nixos-anywhere.packages.${system}.default;
    };
  });

  perSystem =
    { system, ... }:
    {
      devshells.default.packages = [
        inputs.nixos-anywhere.packages.${system}.default
      ];
    };
}
