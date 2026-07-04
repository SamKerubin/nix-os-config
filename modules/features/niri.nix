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
        prefer-no-csd = true;
        spawn-at-startup = [
          (lib.getExe self'.packages.samNoctalia)
          (lib.getExe pkgs.firefox)
          "/etc/profiles/per-user/sam/bin/discord"
          "/etc/profiles/per-user/sam/bin/spotify"
          "${lib.getExe pkgs.niri} msg action focus-workspace browser"
          "${lib.getExe pkgs.bash} -c wl-paste --watch ${lib.getExe pkgs.cliphist} store"
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

          preset-column-widths = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];

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
            offset = {};
          };

          struts = {};
        };

        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        animations = {};
        hotkey-overlay = {
          skip-at-startup = true;
        };

        cursor = {
          xcursor-theme = "breeze-cursor";
          xcursor-size = 32;
        };

        workspaces = {
          "browser" = {};
          "dev" = {};
          "chat" = {};
          "extras" = {};
        };

        window-rules = [
          {
            geometry-corner-radius = 15;
            clip-to-geometry = true;
          }
        ];

        # TODO: Add workspaces and window rules
        # Add spawn-at-startup rules

        binds = {
          "Super+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Super+Q".close-window = {};
          "Super+B".spawn-sh = lib.getExe pkgs.firefox;
          "Super+E".spawn-sh = "${lib.getExe pkgs.nautilus} --new-window";
          "Super+Ctrl+V".spawn-sh = "${lib.getExe pkgs.bash} -c ${lib.getExe pkgs.cliphist} list | ${lib.getExe pkgs.rofi} -dmenu | ${lib.getExe pkgs.cliphist} decode | wl-copy";
          "Super+Ctrl+D".spawn-sh = "/etc/profiles/per-user/sam/bin/discord";
          "Super+Ctrl+M".spawn-sh = "/etc/profiles/per-user/sam/bin/steam";
          "Super+Ctrl+O".spawn-sh = "/etc/profiles/per-user/sam/bin/spotify";
          "Super+Ctrl+N".spawn-sh = "${lib.getExe pkgs.kitty} --class=nvim -- /home/sam/open-nvim.sh";
          "Super+Ctrl+Return".spawn-sh = "${lib.getExe self'.packages.samNoctalia} ipc call launcher toggle";
          "Super+O".toggle-overview = {};
          "Super+Shift+Q".spawn-sh = "${lib.getExe pkgs.bash} -c ${lib.getExe pkgs.niri} msg -j focused-window | ${lib.getExe pkgs.jq} '.pid' | xargs kill -9";
          "Super+1".focus-workspace = 1;
          "Super+2".focus-workspace = 2;
          "Super+3".focus-workspace = 3;
          "Super+4".focus-workspace = 4;
          "Super+5".focus-workspace = 5;
          "Super+6".focus-workspace = 6;
          "Super+7".focus-workspace = 7;
          "Super+8".focus-workspace = 8;
          "Super+9".focus-workspace = 9;
          "Super+Shift+1".move-column-to-workspace = 1;
          "Super+Shift+2".move-column-to-workspace = 2;
          "Super+Shift+3".move-column-to-workspace = 3;
          "Super+Shift+4".move-column-to-workspace = 4;
          "Super+Shift+5".move-column-to-workspace = 5;
          "Super+Shift+6".move-column-to-workspace = 6;
          "Super+Shift+7".move-column-to-workspace = 7;
          "Super+Shift+8".move-column-to-workspace = 8;
          "Super+Shift+9".move-column-to-workspace = 9;
          "Super+Left".focus-column-left = {};
          "Super+Down".focus-window-down = {};
          "Super+Up".focus-window-up = {};
          "Super+Right".focus-column-right = {};
          "Super+H".focus-column-left = {};
          "Super+J".focus-window-down = {};
          "Super+K".focus-window-up = {};
          "Super+L".focus-column-right = {};
          "Super+Ctrl+Left".move-column-left = {};
          "Super+Ctrl+Down".move-window-down = {};
          "Super+Ctrl+Up".move-window-up = {};
          "Super+Ctrl+Right".move-column-right = {};
          "Super+Ctrl+H".move-column-left = {};
          "Super+Ctrl+J".move-window-down = {};
          "Super+Ctrl+K".move-window-up = {};
          "Super+Ctrl+L".move-column-right = {};
          "Super+U".focus-workspace-down = {};
          "Super+I".focus-workspace-up = {};
          "Super+Ctrl+U".move-workspace-down = {};
          "Super+Ctrl+I".move-workspace-up = {};
          "Super+F".maximize-column = {};
          "Super+Shift+F".fullscreen-window = {};
          "Super+V".toggle-window-floating = {};
          "Super+Shift+V".switch-focus-between-floating-and-tiling = {};
          "Print".screenshot = {};
          "Ctrl+Print".screenshot-screen = {};
          "Alt+Print".screenshot-window = {};
        };
      };
    };
  };
}
