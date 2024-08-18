# Nixvim

My nixvim configuration

## Usage

This configuration is currently hardcoded to the home-manager configurations and can be used from there.
Just simply run any ```neovim``` command.
```bash
nvim .
```

## Configuring

To start configuring, just add or modify the nix files in `./config`.
If you add a new configuration file, remember to add it to the
[`config/default.nix`](./config/default.nix) file

## Testing your new configuration

To test your configuration simply run the following command

```
nix run .
```

## Updating

```bash
sudo nix flake update
```

For more information look at: [NixOS docs](https://nixos.wiki/wiki/flakes)
