{ pkgs
, inputs
, username
, modulePrefix
, system
, ...
}:
let
  prefix = modulePrefix + /home;
in
{
  imports = [
    (prefix + /dunst.nix)
    (import (prefix + /hyprland.nix) {
      monitor = ",highres,auto,1.25";
      inherit username;
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

    stateVersion = "24.05"; # WARN: DO NOT! EDIT!!
  };
}
