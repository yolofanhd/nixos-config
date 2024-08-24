{ config, pkgs, inputs, system, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.username = "pi";
  home.homeDirectory = "/home/pi";

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "vicmd";
    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
      share = true;
      size = 10000;
    };
    historySubstringSearch.enable = true;
    prezto = {
      enable = true;
      color = true;
      editor = {
        dotExpansion = true;
	keymap = "vi";
	promptContext = true;
      };
      prompt = {
        pwdLength = "full";
      };
      python = {
        virtualenvAutoSwitch = true;
	virtualenvInitialize = true;
      };
      terminal = {
        autoTitle = true;
      };
      tmux = {
        autoStartLocal = true;
      };
      utility.safeOps = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
	"python"
	"man"
	"colored-man-pages"
	"tmux"
	"zsh-interactive-cd"
	"sudo"
      ];
    };
  };

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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;[
    zsh
    tmux
    inputs.myvim.packages."${system}".default
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fractalix/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
