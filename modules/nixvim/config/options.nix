{self, ...}: {
  globalOpts = {
    # Line numbers
    number = true;
    relativenumber = true;

    # Always show the signcolumn, otherwise text would be shifted when displaying error icons
    signcolumn = "yes";

    swapfile = false;
    backup = false;
    undodir = "~/.vim-undodir";
    syntax = "OFF";

    termguicolors = true;
    encoding = "utf8";
    fileencoding = "utf8";
    
    hlsearch = false;
    incsearch = true;

    splitright = true;
    splitbelow = true;

    # Search
    ignorecase = true;
    smartcase = true;

    # Tab defaults (might get overwritten by an LSP server)
    smartindent = true;
    tabstop = 4;
    shiftwidth = 4;
    softtabstop = 0;
    expandtab = true;
    smarttab = true;

    # System clipboard support, needs xclip/wl-clipboard
    clipboard = "unnamedplus";

    # Highlight the current line
    cursorline = true;

    # Show line and column when searching
    ruler = true;

    # Global substitution by default
    gdefault = true;

    # Start scrolling when the cursor is X lines away from the top/bottom
    scrolloff = 4;
  };

  userCommands = {
    Q.command = "q";
    Q.bang = true;
    Wq.command = "q";
    Wq.bang = true;
    WQ.command = "q";
    WQ.bang = true;
    W.command = "q";
    W.bang = true;
  };

  globals.mapleader = "`";

  autoCmd = [
    {
      event = [ "BufEnter" "BufWinEnter" ];
      command = "set nofoldenable";
    }
    {
      event = [ "VimEnter" ];
      command = "Neotree";
    }
  ];

  highlight = {
    Comment = {
      fg = "#ff00ff";
      bg = "#000000";
      underline = true;
      bold = true;
    };
  };
}
