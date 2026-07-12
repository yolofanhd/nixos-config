{
  lib,
  pkgs,
  username,
  modulePrefix,
  ...
}:
let
  prefix = modulePrefix + /home;
in
{
  imports = [
    (prefix + /tmux.nix)
    (prefix + /zsh.nix)
    (prefix + /kitty.nix)
    (prefix + /zathura.nix)
  ];

  targets.darwin = {
    linkApps.enable = false;
    copyApps.enable = false;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark";
      theme_background = false;
    };
  };

  programs.zsh.prezto.tmux = {
    autoStartLocal = lib.mkForce false;
    autoStartRemote = lib.mkForce false;
  };

  programs.ssh = {
    enable = true;
    matchBlocks.github = {
      host = "github.com";
      hostname = "github.com";
      user = "git";
      identityFile = "/Users/${username}/.ssh/github-ssh";
      identitiesOnly = true;
    };
  };

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    packages = with pkgs; [
      btop
      tmux
      zsh
    ];

    file.".gitignore_global".source = prefix + /git/.gitignore_global;

    sessionVariables = {
      EDITOR = "vim";
    };

    stateVersion = "24.05";
  };
}
