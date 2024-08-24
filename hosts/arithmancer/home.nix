{ pkgs
, inputs
, username
, system
, ...
}:
let
  prefix = ./../../modules/home;
in
{
  imports = [
    (prefix + /dunst.nix)
    (import (prefix + /hyprland.nix) {
      monitor = ",highrr,auto,1.25";
    })
    (prefix + /tmux.nix)
    (prefix + /waybar-sidebar.nix)
    (prefix + /wofi.nix)
    (prefix + /zsh.nix)
    (prefix + /kitty.nix)
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      kitty
      zsh
      tmux

      git

      firefox # browser
      spotify
      obsidian # note taking app

      cheat
      swww # background images

      wl-clipboard
      slurp # for screenshotting in wayland cli tool
      wayshot # for screenshotting in wayland cli tool

      anki-bin # learning cards
      texlive.combined.scheme-full # latex support

      zathura # pdf reader

      steam

      inputs.myvim.packages."${system}".default

      (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    ];

    file = { };

    sessionVariables = {
      EDITOR = "nvim";
    };

    stateVersion = "23.11"; # DO NOT! EDIT!!
  };
}
