{ self, inputs, ... }: { 
  flake.nixosModules.niri = { pkgs, config, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.samNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.samNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      
      settings = {
        prefer-no-csd = {};
        spawn-at-startup = [
          (lib.getExe self'.packages.samNoctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input = {
          keyboard = {
            xkb = {
              layout = "latam";
            };

            repeat-rate = 35;
            repeat-delay = 500;
            numlock = {};
          };

          touchpad = {
            off = {};
          };

          warp-mouse-to-focus = {};
          focus-follows-mouse = {};
        };

        layout = {
          gaps = 8;
          
          center-focused-column = "never";
    
          preset-column-widths = {
            proportion = 0.66667;
          };

          default-column-width = {
            proportion = 0.5;
          };

          focus-ring = {
            width = 1.5;
            active-color = "rgba(125, 100, 120, 0.1)";
            inactive-color = "rgba(50, 50, 50, 0.1)";
          };

          border = {
            off = {};
          };
          
          shadow = {
            softness = 30;
            spread = 5;
            color = "#0007";
          };

          struts = {};
        };

        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        animations = {};
        hotkey-overlay = {
          skip-at-startup = {};
        };

        # TODO: Add workspaces and window rules
        # Add spawn-at-startup rules

        binds = {
          "Super+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Super+Q".close-window = {};
          "Super+S".spawn-sh = "${lib.getExe self'.packages.samNoctalia} ipc call launcher toggle";
          "Super+B".spawn-sh = lib.getExe pkgs.firefox;
          "Super+E".spawn-sh = "${lib.getExe pkgs.nautilus} --new-window";
        };
      };
    };
  };
}
