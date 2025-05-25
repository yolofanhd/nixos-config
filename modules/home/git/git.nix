{ age, ... }: {
  programs.git = {
    enable = true;
    extraConfig = {
      alias = {
        branch = "branch -vv";
        log = "log --decorate --all --graph";
      };
      core = {
        whitespace = "trailing-space,space-before-tab";
        excludesfile = "~/.gitignore_global";
        editor = "nvim";
        hooksPath = "~/.git/hooks";
      };
      color = {
        ui = true;
        branch = {
          current = "green";
          local = "blue";
          remote = "cyan";
          merge = "red";
          upstream = "yellow";
        };
        diff = "auto";
        status = "auto";
      };
      format = {
        pretty = "%C(yellow)%h%Creset %s %Cgreen(%cr)%Creset";
      };
      completion = {
        branch = true;
      };
      fetch = {
        prune = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      init = {
        defaultBranch = "main";
      };
      branch = {
        autosetupmerge = true;
        sort = "-committerdate";
      };
      status = {
        showBranch = true;
      };
      pack = {
        threads = 0;
        compression = 9;
      };
    };

    includes = [
      {
        condition = "gitdir:~/fun/";
        contents = {
          user = {
            name = "yolofanhd";
            email = "76175017+yolofanhd@users.noreply.github.com";
            signingkey = "61C2FFE6056B65B6";
          };
          commit = {
            gpgSign = true;
          };
        };
      }
      {
        condition = "gitdir:~/uni/";
        inherit (age.secrets.uni-gitconfig) path;
      }
    ];
  };
}
