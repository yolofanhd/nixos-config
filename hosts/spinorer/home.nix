{ pkgs
, inputs
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

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      kitty
      zsh
      tmux

      git

      firefox
      spotify
      obsidian

      cheat # for cheatsheets and stuff
      swww

      wl-clipboard
      slurp
      wayshot

      anki-bin
      texlive.combined.scheme-full

      zathura

      inputs.myvim.packages."x86_64-linux".default

      (pkgs.nerdfonts.override {
        fonts = [ "FantasqueSansMono" ];
      })
    ];

    file = { };

    sessionVariables = {
      EDITOR = "nvim";
    };

    stateVersion = "23.11"; # do not change (could contain breaking changes)
  };
}
