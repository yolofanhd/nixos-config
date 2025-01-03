{
  programs.wofi = {
    enable = true;
    settings = {
      width = 300;
      height = 1130;
      location = "left";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
      layer = "overlay";
    };
    style = ''
      window {
        margin: 0px;
        border: 2px solid #333;
        background-color: #1b1b1b;
        border-radius: 10px;
        }

        #input {
        margin: 5px;
        border: none;
        color: #f8f8f2;
        border-radius: 8px;
        background-color: #2b2b2b;
        }

        #inner-box {
        margin: 5px;
        border: none;
        border-radius: 10px;
        background-color: #2b2b2b;
        }

        #outer-box {
        margin: 5px;
        border: none;
        border-radius: 10px;
        background-color: #1b1b1b;
        }

        #scroll {
        margin: 0px;
        border-radius: 15px;
        border: none;
        }

        #text {
          border-radius: 15px;
          margin: 5px;
          border: none;
          color: #f8f8f2;
        }

        #entry.activatable #text {
          color: #282a36;
        }

        #entry > * {
          color: #f8f8f2;
        }

        #entry:selected {
            border-radius: 2px;
            background-color: #1b441b;
        }

        #entry:selected #text {
            border-radius: 2px;
        }
    '';
  };
}
