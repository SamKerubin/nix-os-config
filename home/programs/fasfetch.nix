{ pkgs, ... }: {
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com";
      
      logo = {
        type = "auto";
        source = "${./assets/pan-kisser.jpg}";
        width = 20;
        height = 10;
        padding = {
          left = 5;
          top = 2;
        };
      };

      display = {
        key = {
          width = 12;
        };
        separator = "    ";
        bar = {
          char = {
            elapsed = "█";
            total = "░";
          };

          border = {
            left = "[";
            right = "]";
          };

          width = 10;
        };
      };
      modules = [
        "break"
        {
          type = "title";
          key = "user";
          format = "{user-name}";
        }
        {
          type = "title";
          key = "hname";
          format = "{host-name}";
        }
        {
          type = "command";
          key = "os age";
          text = ''
            echo $(( ($(date +%s) - $(stat -c %W /)) / 86400 )) days
          '';
        }
        {
          type = "uptime";
          key = "uptime";
        }
        {
          type = "os";
          key = "distro";
          format = "{pretty-name} {arch}";
        }
        {
          type = "wm";
          key = "wm";
        }
        {
          type = "kernel";
          key = "kernel";
        }
        {
          type = "terminal";
          key = "term";
        }
        {
          type = "shell";
          key = "shell";
        }
        {
          type = "cpu";
          key = "cpu";
        }
        {
          type = "battery";
          key = "battery";
          percent = {
            type = 2;
            green = 70;
            yellow = 20;
          };
        }
        {
          type = "disk";
          key = "disk";
          percent = {
            type = 2;
            green = 50;
            yellow = 75;
          };
        }
        {
          type = "memory";
          key = "ram";
          percent = {
            type = 2;
            green = 40;
            yellow = 80;
          };
        }
        {
          type = "colors";
          key = "colors";
          symbol = "circle";
        }
      ];
    };
  };
}
