set dotenv-load := true

# Justfile to make rebuilding systems easier

# Rebuild system based on HOST set in .env.
rebuild:
    #!/usr/bin/env bash
    set -euo pipefail

    host="${HOST:?Set HOST in .env, for example HOST=macos or HOST=arithmancer}"

    case "$host" in
      macos|darwin)
        sudo darwin-rebuild switch --flake "path:${PWD}#macos"
        ;;
      arithmancer|rpi4|rpi5)
        hardware_config=/etc/nixos/hardware-configuration.nix
        if [[ ! -r "$hardware_config" ]]; then
          printf 'Required hardware configuration is not readable: %s\n' "$hardware_config" >&2
          exit 1
        fi

        export NIXOS_HARDWARE_CONFIG="$hardware_config"
        sudo --preserve-env=NIXOS_HARDWARE_CONFIG \
          nixos-rebuild switch --impure --flake "./#${host}"
        ;;
      *)
        printf 'Unknown HOST %q. Expected macos, arithmancer, rpi4, or rpi5.\n' "$host" >&2
        exit 1
        ;;
    esac

# Checks formatting and evaluates every declared system without mutating the repository.
test:
    #!/usr/bin/env bash
    set -euo pipefail

    nix fmt -- --check .
    nix flake check --no-build
    nix eval --raw .#darwinConfigurations.macos.config.system.build.toplevel.drvPath
    printf '\n'
    nix eval --raw .#nixosConfigurations.arithmancer.config.system.build.toplevel.drvPath
    printf '\n'
    nix eval --raw .#nixosConfigurations.rpi4.config.system.build.toplevel.drvPath
    printf '\n'
    nix eval --raw .#nixosConfigurations.rpi5.config.system.build.toplevel.drvPath
    printf '\n'

# Runs nix flake update & just rebuild
update:
    #!/usr/bin/env bash
    set -euo pipefail

    nix flake update
    just rebuild
