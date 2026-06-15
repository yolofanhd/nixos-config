set dotenv-load := true

# Justfile to make rebuilding systems easier

# Rebuild system based on HOST set in .env.
rebuild:
    #!/usr/bin/env bash
    set -euo pipefail

    host="${HOST:?Set HOST in .env, for example HOST=macos or HOST=arithmancer}"

    if [[ "$host" == "macos" || "$host" == "darwin" ]]; then
      darwin-rebuild switch --flake "./#macos"
    else
      ln -f /etc/nixos/hardware-configuration.nix ./hardware-configuration.nix
      git add ./hardware-configuration.nix -f
      trap 'git restore --staged hardware-configuration.nix || true' EXIT
      sudo nixos-rebuild switch --flake "./#${host}"
    fi

# Runs nix flake check
test:
    #!/usr/bin/env bash
    set -euo pipefail

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
    trap 'git restore --staged hardware-configuration.nix || true' EXIT
    nix flake check

# Runs nix flake update & just rebuild
update:
    #!/usr/bin/env bash
    set -euo pipefail

    nix flake update
    just rebuild
