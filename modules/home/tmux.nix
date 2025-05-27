{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "xterm-256color";
    keyMode = "vi";
    newSession = true;
    mouse = true;
    prefix = "C-a";
    shortcut = "a";
    sensibleOnTop = true;
    secureSocket = true;
    shell = "${pkgs.zsh}/bin/zsh";
    escapeTime = 0;
    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"
    '';
    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
      {
        plugin = tmuxPlugins.gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox 'dark'
          set -g @tmux-gruvbox-statusbar-alpha 'true'
        '';
      }
    ];
  };
}
