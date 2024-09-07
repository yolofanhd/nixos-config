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

  programs.home-manager.enable = true;
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    file = { };
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "24.11"; #WARN: Do NOT! edit!!
  };
}
