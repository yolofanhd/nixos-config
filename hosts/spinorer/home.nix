{ pkgs
, username
, modulePrefix
, ...
}:
let
  prefix = modulePrefix + /home;
in
{
  imports = [
    (prefix + /dunst.nix)
    (import (prefix + /hyprland.nix) {
      monitor = ",highrr,auto,2";
    })
    (prefix + /tmux.nix)
    (prefix + /waybar-topbar.nix)
    (prefix + /wofi.nix)
    (prefix + /zsh.nix)
    (prefix + /kitty.nix)
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # INFO: Only contains packages related to home configuration
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      kitty
      swww
      slurp
      tmux
      wayshot
      wl-clipboard
      zsh
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    stateVersion = "24.11"; # WARN: do not change (could contain breaking changes)
  };
}
