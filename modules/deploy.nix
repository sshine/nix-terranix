{ inputs, self, ... }:
{
  flake.deploy.nodes.mechanikube = {
    hostname = "kube.mechanicus.xyz";
    sshUser = "root";
    profiles.system = {
      user = "root";
      remoteBuild = true;
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.mechanikube;
    };
  };
}
