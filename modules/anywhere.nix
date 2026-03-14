{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      devshells.default.packages = [
        inputs.nixos-anywhere.packages.${system}.default
      ];
    };
}
