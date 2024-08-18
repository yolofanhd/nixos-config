# My nixos config

This is my nixos config. It's intended for the use of 2 devices. A 3rd configuration for [another host](https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi) will be available in the future!

## Project structure

- **hosts**\
  contain a basic setup for each host (e.g. notebook, pc, etc.)\
  the goal is to keep those configurations at a bare minimum and import everything thats needed from other modules

- **modules**\
  contain a basic setup for application and their configurations
  - **home**\
    contains setup for home-manager specific stuff
  - **[nixvim](./modules/nixvim/README.md)**\
    might get refactored to its own repo in the future

## Installation and setup

As this configuration utilizes flakes it is fairly simple to install and setup:

```bash
sudo nixos-rebuild switch --flake '/etc/nixos/#<host-name>'
```

### Updating the configuration

The following two commands are used to update 1. the nix flake and 2. the system.
The nixvim configuration should also be updated with the first command.
That has to be done manually for the time being.

If any error occurs when updating or building feel free to open an issue or a pr :)

```bash
sudo nix flake update
```

```bash
sudo nixos-rebuild switch --flake '/etc/nixos/#<host-name>' --upgrade
```

For more information look at: [NixOS docs](https://nixos.wiki/wiki/flakes)

### Secure boot with lanzaboote

WIP

### disk encryption with nixos

WIP

## Contribution guidelines

This repository uses [convetional commits](https://www.conventionalcommits.org/en/v1.0.0/#summary).<br/>
Just feel free to leave a PR and I might merge it! :D
