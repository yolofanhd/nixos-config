{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "kitty";
    keyMode = "vi";
    newSession = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.sensible;
        extraConfig = "set -g @plugin 'tmux-plugins/tmux-sensible'";
      }
    ];
  };
}
