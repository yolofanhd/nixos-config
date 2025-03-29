{ pkgs, ... }: {
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
        autoStartRemote = true;
        defaultSessionName = "main";
      };
      utility.safeOps = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "git-prompt"
        "python"
        "man"
        "colored-man-pages"
        "rust"
        "kitty"
        "zsh-interactive-cd"
        "sudo"
      ];
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };
}
