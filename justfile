# Show available commands
list:
    @just --list --unsorted

# Initialize
init target='mechanikube':
    nix run .#{{target}}.init

# Plan 
plan target='mechanikube':
    HCLOUD_TOKEN=$(cat hcloud.token) nix run .#{{target}}.plan

apply target='mechanikube':
    HCLOUD_TOKEN=$(cat hcloud.token) nix run .#{{target}}.apply

destroy target='mechanikube':
    HCLOUD_TOKEN=$(cat hcloud.token) nix run .#{{target}}.destroy
