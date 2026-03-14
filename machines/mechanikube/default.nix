{ inputs, self, ... }:
{
  flake.nixosConfigurations.mechanikube = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.mechanikube-config
      inputs.disko.nixosModules.disko
    ];
  };
}
