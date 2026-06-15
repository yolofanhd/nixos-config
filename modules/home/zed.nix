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
    buffer_line_height = "standard";

    project_panel.dock = "left";

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

    terminal.font_family = "FantasqueSansM Nerd Font";
    ui_font_size = 16;
    buffer_font_size = 15.0;
    theme = "Gruvbox Dark Hard";
  };
in
{
  home.file.".config/zed/settings.json".text = builtins.toJSON settings;
}
