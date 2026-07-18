<p align="center">
  <a href="https://nixos.org">
    <picture>
      <source media="(prefers-color-scheme: light)" srcset="https://brand.nixos.org/logos/nixos-logo-rainbow-gradient-black-regular-horizontal-minimal.svg">
      <source media="(prefers-color-scheme: dark)" srcset="https://brand.nixos.org/logos/nixos-logo-rainbow-gradient-white-regular-horizontal-minimal.svg">
      <img src="https://brand.nixos.org/logos/nixos-logo-rainbow-gradient-black-regular-horizontal-minimal.svg" width="500px" alt="NixOS logo">
    </picture>
  </a>
</p>

<h1 align="center">Nix systems configuration</h1>

<p align="center">
  <a href="https://github.com/yolofanhd/nixos-config/actions/workflows/flake-check.yml">
    <img src="https://github.com/yolofanhd/nixos-config/actions/workflows/flake-check.yml/badge.svg?branch=main" alt="Validation status">
  </a>
  <a href="https://nixos.org">
    <img src="https://img.shields.io/badge/Nix-Flakes-5277C3?logo=nixos&logoColor=white" alt="Nix flakes">
  </a>
  <img src="https://img.shields.io/badge/platforms-aarch64--darwin%20%7C%20aarch64--linux%20%7C%20x86__64--linux-555555" alt="Supported platforms">
  <a href="./LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT license">
  </a>
</p>

This flake manages one nix-darwin workstation and three NixOS hosts. Host files
are composition roots; reusable operating-system and Home Manager concerns live
under `modules/`, while machine-specific application choices stay with their
host.

## Hosts

| Flake output  | Platform         | Role                                       |
| ------------- | ---------------- | ------------------------------------------ |
| `macos`       | `aarch64-darwin` | macOS workstation managed by nix-darwin    |
| `arithmancer` | `x86_64-linux`   | NixOS desktop with Hyprland and Lanzaboote |
| `rpi5`        | `aarch64-linux`  | Raspberry Pi 5 and primary k3s server      |
| `rpi4`        | `aarch64-linux`  | Raspberry Pi 4 and k3s agent               |

## Repository layout

- `hosts/` composes each system and contains host-specific package policy.
- `modules/darwin/` contains reusable nix-darwin services and defaults.
- `modules/nixos/` contains reusable NixOS services and hardware-independent
  policy.
- `modules/home/` contains shared Home Manager program configuration.
- `packages/` contains locally packaged software.
- `secrets/` contains Agenix declarations and encrypted payloads only.

## Validation

Enter the pinned development environment before running project commands:

```sh
nix develop
just test
```

`just test` checks formatting, runs `nix flake check --no-build`, and evaluates
the top-level derivation for every declared NixOS and nix-darwin host. It does
not create files or alter the Git index. The equivalent individual commands are:

```sh
nix fmt -- --check .
nix flake check --no-build
```

Pure evaluation deliberately excludes machine-generated filesystem and boot
configuration. It uses each host's explicit platform and an evaluation-only
container boundary, so a checkout can be validated on any supported machine
without a fake `hardware-configuration.nix`.

## Rebuilding

Copy the environment template and select a declared host:

```sh
cp .env.sample .env
$EDITOR .env
nix develop --command just rebuild
```

For NixOS hosts, `just rebuild` requires a readable
`/etc/nixos/hardware-configuration.nix`, passes it through
`NIXOS_HARDWARE_CONFIG`, and enables impure evaluation only for the activation.
The hardware file is never copied into this repository. The equivalent manual
command is:

```sh
export NIXOS_HARDWARE_CONFIG=/etc/nixos/hardware-configuration.nix
sudo --preserve-env=NIXOS_HARDWARE_CONFIG \
  nixos-rebuild switch --impure --flake .#arithmancer
```

On macOS, select `HOST=macos`; the recipe runs:

```sh
sudo darwin-rebuild switch --flake "path:$PWD#macos"
```

`just update` updates `flake.lock` and then rebuilds the selected host. Review
dependency changes before activation.

## Credentials and first installation

The configuration intentionally contains no initial login password or password
hash. NixOS keeps mutable password management enabled, so existing passwords
remain valid across rebuilds. During a fresh installation, set the user password
from the installer before rebooting:

```sh
sudo nixos-enter --root /mnt -c 'passwd fractalix'
```

Agenix stores only encrypted files in Git. Recipient declarations are in
`secrets/secrets.nix`; decrypted paths and ownership are declared by the Agenix
modules. Edit a secret using an authorized identity, for example:

```sh
nix develop --command agenix -e secrets/kubernetes.age
```

Never interpolate decrypted values into Nix strings. k3s consumes its credential
through the runtime `tokenFile` option, and the decrypted token is root-readable
only.

## Security-sensitive defaults

- The Raspberry Pi firewall is enabled. k3s permits `6443/tcp` for the API,
  `10250/tcp` for kubelet, and `8472/udp` for Flannel VXLAN. The primary server
  additionally permits `2379-2380/tcp` for embedded etcd.
- The arithmancer secure-boot policy is loaded only with its real hardware
  configuration. Follow the upstream Lanzaboote quick start before enabling it
  on a new installation.
- Unfree packages are allowed because the declared workstation application sets
  require them. Package selection remains explicit in host-local modules.
- Host selection from `.env` is validated before any privileged activation, and
  `sudo` is restricted to the rebuild command.

No workflow in this repository activates a system automatically. Inspect the
diff and run `just test` before choosing to rebuild.

## Contributing and security

Contributions are welcome when they preserve the repository's host-oriented
architecture. See [CONTRIBUTING.md](./CONTRIBUTING.md) for the validation and
submission workflow.

Do not open public issues for suspected vulnerabilities or exposed sensitive
data. Follow [SECURITY.md](./SECURITY.md) instead.
