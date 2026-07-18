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
    (prefix + /btop.nix)
    (prefix + /tmux.nix)
    (prefix + /zsh.nix)
    (prefix + /kitty.nix)
    (prefix + /nvim.nix)
    (prefix + /ssh.nix)
    (prefix + /zathura.nix)
  ];

  targets.darwin = {
    linkApps.enable = false;
    copyApps.enable = false;
  };

  programs.zsh.prezto.tmux = {
    autoStartLocal = false;
    autoStartRemote = false;
  };

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    packages = with pkgs; [
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
