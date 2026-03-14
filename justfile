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

# Destroy previously created infrastructure
destroy target='mechanikube':
    HCLOUD_TOKEN=$(cat hcloud.token) nix run .#{{target}}.destroy
