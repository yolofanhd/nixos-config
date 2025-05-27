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
    (prefix + /waybar/sidebar.nix)
    (prefix + /wofi.nix)
    (prefix + /zsh.nix)
    (prefix + /kitty.nix)
    (prefix + /git/git.nix)
  ];

  # INFO: Only contains packages related to home configuration
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark";
      theme_background = false;
    };
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      kitty
      zsh
      tmux
      inputs.myvim.packages.${system}.default
    ];

    file.".gitignore_global".source = prefix + /git/.gitignore_global;
    file.".git/hooks/commit-msg".source = prefix + /git/commit-msg;

    sessionVariables = {
      EDITOR = "nvim";
    };

    stateVersion = "24.05"; # WARN: DO NOT! EDIT!!
  };
}
