{ pkgs, ... }: {
  plugins = {
    # Buffer bar
    bufferline = {
      enable = true;
      # settings.options = {
      #   diagnostics = "nvim_lsp";
      #   offsets = [
      #     {
      #       filetype = "neo-tree";
      #       text = "File Explorer";
      #       text_align = "left";
      #       separator = true;
      #     }
      #   ];
      # };
    };

    # Status bar
    lualine = {
      enable = true;
    };

    # Includes all parsers for treesitter
    treesitter = {
      enable = true;
    };

    # Auto-tagging
    ts-autotag = {
      enable = true;
    };

    # Autopairs
    nvim-autopairs = {
      enable = true;
    };

    none-ls = {
      enable = true;
      settings = {
        cmd = [ "bash -c nvim" ];
        debug = true;
      };
      sources = {
        code_actions = {
          statix.enable = true;
          gitsigns.enable = true;
        };
        diagnostics = {
          statix.enable = true;
          deadnix.enable = true;
          pylint.enable = true;
          checkstyle.enable = true;
        };
        formatting = {
          alejandra.enable = true;
          stylua.enable = true;
          shfmt.enable = true;
          nixpkgs_fmt.enable = true;
          google_java_format.enable = false;
          prettier = {
            enable = true;
            disableTsServerFormatter = true;
          };
          black = {
            enable = true;
            # settings = ''
            #   {
            #     extra_args = { "--fast" },
            #   }
            # '';
          };
        };
        completion = {
          luasnip.enable = true;
          spell.enable = true;
        };
      };
    };

    # Notify
    notify = {
      enable = true;
      backgroundColour = "#1e1e2e";
      fps = 60;
      render = "default";
      timeout = 500;
      topDown = true;
    };

    # Persistence
    persistence.enable = true;

    # Debugger
    dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = "●";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "●";
          texthl = "DapBreakpointCondition";
        };
        dapLogPoint = {
          text = "◆";
          texthl = "DapLogPoint";
        };
      };
      extensions = {
        dap-python = {
          enable = true;
        };
        dap-ui = {
          enable = true;
          floating.mappings = {
            close = [ "<ESC>" "q" ];
          };
        };
        dap-virtual-text = {
          enable = true;
        };
      };
      configurations = {
        java = [
          {
            type = "java";
            request = "launch";
            name = "Debug (Attach) - Remote";
            hostName = "127.0.0.1";
            port = 5005;
          }
        ];
      };
    };

    # Linting
    lint = {
      enable = true;
      lintersByFt = {
        text = [ "vale" ];
        json = [ "jsonlint" ];
        markdown = [ "vale" ];
        rst = [ "vale" ];
        ruby = [ "ruby" ];
        janet = [ "janet" ];
        inko = [ "inko" ];
        clojure = [ "clj-kondo" ];
        dockerfile = [ "hadolint" ];
        terraform = [ "tflint" ];
      };
    };

    # Trouble
    trouble = {
      enable = true;
    };

    # Code snippets
    luasnip = {
      enable = true;
      #extraConfig = {
      #  enable_autosnippets = true;
      #  store_selection_keys = "<Tab>";
      #};
    };

    # Easily toggle comments
    commentary.enable = true;

    # Terminal inside Neovim
    floaterm = {
      enable = true;
    };

    # A community driven snippet collection
    friendly-snippets = {
      enable = true;
    };

    # An awesome git wrapper
    fugitive = {
      enable = true;
    };

    # Easily create annotations
    neogen = {
      enable = true;
    };

    # Git signs in code
    gitsigns = {
      enable = true;
      settings.current_line_blame = true;
    };

    # Markdown preview server
    markdown-preview = {
      enable = true;
      settings.theme = "dark";
    };

    # Good old Telescope
    telescope = {
      enable = true;
      extensions = {
        fzf-native = {
          enable = true;
        };
        file-browser = {
          enable = true;
        };
      };
      settings = {
        defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^.mypy_cache/"
            "^__pycache__/"
            "^output/"
            "^data/"
            "^target/"
            "^build/"
            "%.ipynb"
          ];
        };
      };
    };

    # Todo comments
    todo-comments = {
      enable = true;
      colors = {
        error = [ "DiagnosticError" "ErrorMsg" "#DC2626" ];
        warning = [ "DiagnosticWarn" "WarningMsg" "#FBBF24" ];
        info = [ "DiagnosticInfo" "#2563EB" ];
        hint = [ "DiagnosticHint" "#10B981" ];
        default = [ "Identifier" "#7C3AED" ];
        test = [ "Identifier" "#FF00FF" ];
      };
    };

    # File tree
    neo-tree = {
      enable = true;
      enableDiagnostics = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      enableRefreshOnWrite = true;
      closeIfLastWindow = false;
      popupBorderStyle = "rounded"; # Type: null or one of “NC”, “double”, “none”, “rounded”, “shadow”, “single”, “solid” or raw lua code
      buffers = {
        bindToCwd = false;
        followCurrentFile = {
          enabled = true;
        };
      };
      window = {
        position = "left";
        width = 40;
        height = 15;
        autoExpandWidth = false;
        mappings = {
          "<space>" = "none";
        };
      };
    };

    # Nix expressions in Neovim
    nix = {
      enable = true;
    };

    # Language server
    lsp = {
      enable = true;
      servers = {
        # Average webdev LSPs
        tsserver.enable = true; # TS/JS
        cssls.enable = true; # CSS
        tailwindcss.enable = true; # TailwindCSS
        html.enable = true; # HTML

        # Python
        pyright.enable = true;

        # Markdown
        marksman.enable = true;

        # Nix
        nil-ls.enable = true;

        # Docker
        dockerls.enable = true;

        # Bash
        bashls.enable = true;

        # C/C++
        clangd.enable = true;

        # C#
        csharp-ls.enable = true;

        # Lua
        lua-ls = {
          enable = true;
          settings.telemetry.enable = false;
        };

        # Rust
        rust-analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
          settings = {
            cargo = {
              features = "all";
            };
            procMacro = {
              enable = true;
              ignored = {
                leptos_macro = [ "server" "component" ];
              };
            };
          };
        };
      };
    };
    lsp-format = {
      enable = true;
    };
    lsp-lines = {
      enable = true;
    };
    lsp-status = {
      enable = true;
    };

    rust-tools = {
      enable = true;
      server = {
        procMacro = {
          enable = true;
          ignored = {
            leptos_macro = [ "server" "component" ];
          };
        };
      };
    };
    crates-nvim = {
      enable = true;
    };

    # Dashboard
    alpha = {
      enable = true;
      theme = "dashboard";
      iconsEnabled = true;
    };

    which-key = {
      enable = true;
    };

    cmp = {
      enable = true;
      autoEnableSources = false;
      settings = {
        mapping = {
          __raw = ''
            cmp.mapping.preset.insert({
             ["<C-Space>"] = cmp.mapping.complete(),
             ["<C-n>"] = cmp.mapping.select_next_item(),
             ["<C-p>"] = cmp.mapping.select_prev_item(),
             ["<C-b>"] = cmp.mapping.scroll_docs(-4),
             ["<C-f>"] = cmp.mapping.scroll_docs(4),
             ["<C-e>"] = cmp.mapping.close(),
             ["<C-y>"] = cmp.mapping.confirm({
                 behavior = cmp.ConfirmBehavior.Insert,
                 select = true
               })
             })
          '';
        };
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
        sources = {
          __raw = ''
            cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'vsnip' },
              { name = 'luasnip' },
            }, {
              { name = 'buffer' },
            })
          '';
        };
      };
    };

    cmp-nvim-lsp = {
      enable = true; # Enable suggestions for LSP
    };
    cmp-buffer = {
      enable = true; # Enable suggestions for buffer in current file
    };
    cmp-path = {
      enable = true; # Enable suggestions for file system paths
    };
    cmp_luasnip = {
      enable = true; # Enable suggestions for code snippets
    };
    cmp-cmdline = {
      enable = false; # Enable autocomplete for command line
    };

    undotree = {
      enable = true;
    };
  };

  colorschemes.gruvbox = {
    enable = true;
    settings = {
      transparent_mode = true;
      terima_colors = true;
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    nvim-web-devicons
    clipboard-image-nvim
  ];
}
