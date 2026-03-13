{ inputs, self, ... }:
{
  imports = [ inputs.terranix.flakeModule ];

  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, system, ... }:
    {
      terranix.terranixConfigurations.mechanikube = {
        modules = [ self.terranixModules.mechanikube ];
        terraformWrapper = {
          package = pkgs.opentofu.withPlugins (_: [
            inputs.nixpkgs-terraform-providers-bin.legacyPackages.${system}.providers.hetznercloud.hcloud
          ]);
          prefixText = ''export TF_VAR_hcloud_token="$HCLOUD_TOKEN"'';
        };
      };
    };

  flake.terranixModules.mechanikube = {
    variable.hcloud_token = {
      sensitive = true;
    };

    terraform.required_providers.hcloud.source = "hetznercloud/hcloud";

    provider.hcloud = {
      token = "\${var.hcloud_token}";
    };

    resource.hcloud_server.my_server = {
      image = "debian-13";
      name = "kube.mechanicus.xyz";
      server_type = "cx23";
      location = "nbg1";
      ssh_keys = [ "\${hcloud_ssh_key.t14_key.id}" ];
      public_net = {
        ipv4_enabled = true;
        ipv6_enabled = true;
      };
    };

    resource.hcloud_ssh_key.t14_key = {
      name = "t14";
      public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjsn8RBtdJzneALvXNwyrpFzb6GqzZnHRjjvMjXBzPW";
    };

  };
}
