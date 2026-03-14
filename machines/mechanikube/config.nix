{ self, ... }:
{
  flake.nixosModules.mechanikube-config =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.mechanikube-hardware
        self.nixosModules.mechanikube-disko
      ];

      boot.loader.grub.enable = true;

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
