{ ... }:
let
  settings = {
    agent_servers = {
      gemini.type = "registry";
      github-copilot-cli.type = "registry";
      codex-acp.type = "registry";
    };

    edit_predictions.provider = "copilot";
    which_key.enabled = true;
    vim_mode = true;
    relative_line_numbers = true;
    format_on_save = "on";
    formatter = "prettier";
    buffer_line_height = "standard";
    icon_theme = "Catppuccin Mocha";

    auto_install_extensions.catppuccin-icons = true;

    toolbar = {
      breadcrumbs = false;
      quick_actions = false;
      selections_menu = false;
      agent_review = false;
      code_actions = false;
    };

    tab_bar = {
      show_nav_history_buttons = false;
      show_tab_bar_buttons = false;
    };

    title_bar = {
      show_user_picture = false;
      show_user_menu = false;
      show_sign_in = false;
    };

    collaboration_panel.button = false;
    outline_panel.button = false;
    outline_panel.scrollbar.show = "never";

    scrollbar = {
      show = "never";
      cursors = false;
      git_diff = false;
      search_results = false;
      selected_text = false;
      selected_symbol = false;
      diagnostics = false;
      axes = {
        horizontal = false;
        vertical = false;
      };
    };

    inlay_hints.enabled = true;

    project_panel = {
      dock = "left";
      scrollbar = {
        show = "never";
        horizontal_scroll = false;
      };
    };

    git_panel.scrollbar.show = "never";

    agent = {
      dock = "right";
      default_model = {
        provider = "openai-subscribed";
        model = "gpt-5.5";
        enable_thinking = true;
        effort = "medium";
      };
      enable_feedback = false;
      sidebar_side = "right";
      favorite_models = [ ];
      model_parameters = [ ];
    };

    terminal = {
      font_family = "FantasqueSansM Nerd Font";
      scrollbar.show = "never";
      detect_venv.on = {
        directories = [
          ".env"
          "env"
          ".venv"
          "venv"
        ];
        activate_script = "default";
      };
    };

    prettier = {
      semi = false;
      allowed = true;
      tabWidth = 2;
      bracketSpacing = true;
      jsxSingleQuote = true;
      singleQuote = true;
    };

    ui_font_size = 16;
    buffer_font_size = 15.0;
    theme = "Gruvbox Dark Hard";
  };

  keymap = [
    {
      context = "vim_mode == normal";
      bindings."c l" = [
        "editor::ToggleComments"
        {
          advance_downwards = false;
        }
      ];
      bindings."space t" = "terminal_panel::Toggle";
    }
  ];
in
{
  home.file.".config/zed/settings.json".text = builtins.toJSON settings;
  home.file.".config/zed/keymap.json".text = builtins.toJSON keymap;
}
