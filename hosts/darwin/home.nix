{
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
    (prefix + /zed.nix)
  ];

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark";
      theme_background = false;
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
