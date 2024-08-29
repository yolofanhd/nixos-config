{ pkgs
, username
, ...
}:
let
  prefix = ./../../modules/home;
in
{
  imports = [
    (prefix + /dunst.nix)
    (import (prefix + /hyprland.nix) {
      monitor = ",highrr,auto,1.6";
    })
    (prefix + /tmux.nix)
    (prefix + /waybar-topbar.nix)
    (prefix + /wofi.nix)
    (prefix + /zsh.nix)
    (prefix + /kitty.nix)
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  # Only contains packages related to home configuration
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

    file = { };

    sessionVariables = {
      EDITOR = "nvim";
    };

    stateVersion = "23.11"; # do not change (could contain breaking changes)
  };
}
