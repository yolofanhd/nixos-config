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
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "24.05"; #WARN: Do NOT! edit!!
  };
}
