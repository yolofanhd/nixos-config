{ pkgs
, username
, modulePrefix
, ...
}:
let
  prefix = modulePrefix + /home;
  packageModule = {
    home.packages = with pkgs; [
      kitty
      tmux
      zsh
    ];
  };
in
{
  imports = [
    packageModule
    (prefix + /btop.nix)
    (prefix + /dunst.nix)
    (import (prefix + /hyprland.nix) {
      monitor = ",highres,auto,1.25";
      inherit username;
    })
    (prefix + /nvim.nix)
    (prefix + /ssh.nix)
    (prefix + /tmux.nix)
    (prefix + /waybar/sidebar.nix)
    (prefix + /wofi.nix)
    (prefix + /zsh.nix)
    (prefix + /kitty.nix)
    (prefix + /git/git.nix)
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    file.".gitignore_global".source = prefix + /git/.gitignore_global;
    file.".git/hooks/commit-msg".source = prefix + /git/commit-msg;

    pointerCursor = {
      enable = true;
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    stateVersion = "24.05"; # WARN: DO NOT! EDIT!!
  };
}
