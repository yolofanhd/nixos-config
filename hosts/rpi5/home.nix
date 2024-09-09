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
    stateVersion = "24.11"; #WARN: Do NOT! edit!!
  };
}
