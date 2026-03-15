{ inputs, self, ... }:
{
  flake.nixosConfigurations.mechanikube = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.mechanikube-config
      inputs.disko.nixosModules.disko
    ];
  };

  flake.nixosModules.mechanikube-config =
    {
      lib,
      modulesPath,
      pkgs,
      ...
    }:
    {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
        self.nixosModules.mechanikube-disko
      ];

      boot.loader.grub.enable = true;

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      services.openssh.enable = true;
      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjsn8RBtdJzneALvXNwyrpFzb6GqzZnHRjjvMjXBzPW"
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      system.stateVersion = "25.11";
    };
}
