{ pkgs
, username
, ...
}:
let
  prefix = ./../../modules/home;
in
{
  imports = [
    (prefix + /tmux.nix)
    (prefix + /zsh.nix)
  ];
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    zsh
    tmux
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    file = { };
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "23.11"; #WARN: Do NOT! edit!!
  };
  programs.home-manager.enable = true;
}
