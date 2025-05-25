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
    rm hardware-configuration.nix
    echo "{" > hardware-configuration.nix
    echo "nixpkgs.hostPlatform = \"x86_64-linux\";" >> hardware-configuration.nix

    echo "fileSystems.\"/\" = {" >> hardware-configuration.nix
    echo "device = \"/dev/null\";" >> hardware-configuration.nix
    echo "fsType = \"ext4\";" >> hardware-configuration.nix
    echo "};" >> hardware-configuration.nix

    echo "fileSystems.\"/boot\" = {" >> hardware-configuration.nix
    echo "device = \"/dev/null\";" >> hardware-configuration.nix
    echo "fsType = \"vfat\";" >> hardware-configuration.nix
    echo "};" >> hardware-configuration.nix

    echo "}" >> hardware-configuration.nix
    git add ./hardware-configuration.nix -f
    nix flake check
    git restore --staged hardware-configuration.nix
