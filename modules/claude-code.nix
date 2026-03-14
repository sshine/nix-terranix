{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      devshells.default.packages = [
        pkgs.claude-code
      ];
    };
}
