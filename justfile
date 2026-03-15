# Show available commands
list:
    @just --list --unsorted

# Prepare working directory
init target='mechanikube':
    nix run .#{{target}}.init

# Show planned changes
plan target='mechanikube':
    HCLOUD_TOKEN=$(cat hcloud.token) nix run .#{{target}}.plan

# Create or update infrastructure
apply target='mechanikube':
    HCLOUD_TOKEN=$(cat hcloud.token) nix run .#{{target}}.apply

# Install NixOS using nixos-anywhere
install target='mechanikube':
    nix run .#nixos-anywhere -- --flake '.#mechanikube' --target-host root@kube.mechanicus.xyz --build-on-remote

# Destroy previously created infrastructure
destroy target='mechanikube':
    HCLOUD_TOKEN=$(cat hcloud.token) nix run .#{{target}}.destroy
