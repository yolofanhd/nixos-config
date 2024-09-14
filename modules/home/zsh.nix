{
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
        "rust"
        "tmux"
        "zsh-interactive-cd"
        "sudo"
      ];
    };
  };
}
