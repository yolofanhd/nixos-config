# Justfile to make rebuilding nixos systems easier

# Rebuild system based on host set in .env
# Links /etc/nixos/hardware-configuraiton.nix
rebuild:
    ln /etc/nixos/hardware-configuration.nix ./ -f
    git add ./hardware-configuration.nix -f
    sudo nixos-rebuild switch --flake ./#$($HOST)
    git restore --staged hardware-configuration.nix

# RUns nix flake check
test:
    touch hardware-configuration.nix
    git add ./hardware-configuration.nix -f
    nix flake check
    git restore --staged hardware-configuration.nix
