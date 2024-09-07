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
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      kitty
      zsh
      tmux
      inputs.myvim.packages.${system}.default
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
    nixpkgs.config.allowUnfree = true;
    programs.home-manager.enable = true;
    stateVersion = "24.11"; # WARN: DO NOT! EDIT!!
  };
}
