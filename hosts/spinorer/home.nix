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
      monitor = ",highrr,auto,2";
      inherit username;
    })
    (prefix + /tmux.nix)
    (prefix + /waybar/topbar.nix)
    (prefix + /wofi.nix)
    (prefix + /zsh.nix)
    (prefix + /kitty.nix)
    (prefix + /git/git.nix)
  ];

  # INFO: Only contains packages related to home configuration
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      kitty
      swww
      slurp
      tmux
      inputs.myvim.packages.${system}.default
    ];

    file.".gitignore_global".source = prefix + /git/.gitignore_global;
    file.".git/hooks/commit-msg".source = prefix + /git/commit-msg;

    sessionVariables = {
      EDITOR = "nvim";
    };

    stateVersion = "24.11"; # WARN: do not change (could contain breaking changes)
  };
}
