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
          "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XCURSOR_SIZE XCURSOR_THEME"
          "dbus-update-activation-environment --all"
          "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XCURSOR_SIZE XCURSOR_THEME"

          "/etc/profiles/per-user/sam/bin/discord"
          "/etc/profiles/per-user/sam/bin/spotify"
          "kitty --class toiletmsg --hold sh -c 'toilet -F border --gay FAGGOT -f mono12 -w 60; toilet -F border --gay Sam\\'s NixOS :3 -f mono12 -w 60'"
          "kitty --class fastfetch --hold fastfetch"
          "niri msg action focus-workspace browser"
          "wl-paste --watch cliphist store"
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
        };

        layout = {
          gaps = 8;

          center-focused-column = "never";

          background-color = "transparent";

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
            active-color = "rgba(203, 166, 247, 0.5)";
            inactive-color = "rgba(113, 98, 143, 0.5)";
          };

          border = {
            off = {};
            width = 1.5;
          };

          shadow = {
            softness = 30;
            spread = 5;
            color = "#00000066";
            offset = {};
          };

          struts = {};
        };

        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        animations = {};
        hotkey-overlay = {
          skip-at-startup = true;
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
          {
            matches = [
              { app-id = "firefox"; }
              { app-id = "^nvim$"; }
              { app-id = "GitHub Desktop"; }
              { app-id = "discord"; }
              { app-id = "Spotify"; }
            ];
            open-maximized = true;
            open-focused = false;
          }
          {
            matches = [
              { app-id = "^nvim-terminal$"; }
            ];
            open-maximized = true;
            open-on-workspace = "dev";
          }
          {
            matches = [
              { app-id = "firefox"; }
            ];
            open-on-workspace = "browser";
          }
          {
            matches = [
              { app-id = "nvim"; }
              { app-id = "GitHub Desktop"; }
            ];
            open-on-workspace = "dev";
          }
          {
            matches = [
              { app-id = "discord"; }
              { app-id = "Spotify"; }
            ];
            open-on-workspace = "chat";
          }
          {
            matches = [
              { app-id = "nvim"; }
              { app-id = "kitty"; }
              { app-id = "Spotify"; }
              { app-id = "nvim-terminal"; }
              { app-id = "fastfetch"; }
              { app-id = "toiletmsg"; }
            ];
            opacity = 0.7;
            background-effect = { blur = true; };
          }
          {
            matches = [
              {
                title = "^Picture-in-Picture$";
                app-id = "^firefox$";
              }
            ];
            open-floating = true;
          }
          {
            matches = [
              { app-id = "toiletmsg"; }
              { app-id = "fastfetch"; }
            ];
            open-on-workspace = "extras";
          }
          {
            matches = [
              { app-id = "toiletmsg"; }
            ];
            default-column-width = { proportion = 0.5; };
          }
          {
            matches = [
              { app-id = "fastfetch"; }
            ];
            default-column-width = { proportion = 0.5; };
          }
        ];

        layer-rules = [
          {
            matches = [
              { namespace = "^noctalia-wallpaper*"; }
            ];
            place-within-backdrop = true;
          }
        ];

        binds = {
          "Super+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Super+Q".close-window = {};
          "Super+B".spawn-sh = lib.getExe pkgs.firefox;
          "Super+E".spawn-sh = "${lib.getExe pkgs.nautilus} --new-window";
          "Super+Ctrl+V".spawn-sh = "bash -c 'cliphist list | rofi -dmenu | cliphist decode | wl-copy'";
          "Super+Ctrl+D".spawn-sh = "/etc/profiles/per-user/sam/bin/discord";
          "Super+Ctrl+M".spawn-sh = "/etc/profiles/per-user/sam/bin/steam";
          "Super+Ctrl+O".spawn-sh = "/etc/profiles/per-user/sam/bin/spotify";
          "Super+Ctrl+N".spawn-sh = "kitty --class=nvim -- open-nvim";
          "Super+Ctrl+Return".spawn-sh = "${lib.getExe self'.packages.samNoctalia} ipc call launcher toggle";
          "Super+O".toggle-overview = {};
          "Super+Shift+Q".spawn-sh = "bash -c 'niri msg -j focused-window' | jq '.pid' | xargs kill -9";
          "Super+Ctrl+Q".spawn-sh = "${lib.getExe self'.packages.samNoctalia} ipc call sessionMenu toggle";
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
          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; 
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86AudioPlay".spawn-sh = "playerctl play-pause";
          "XF86AudioStop".spawn-sh = "playerctl stop";
          "XF86AudioPrev".spawn-sh = "playerctl previous";
          "XF86AudioNext".spawn-sh = "playerctl next";
          "XF86MonBrightnessUp".spawn-sh = "brightnessctl --class=backlight set +10%";
          "XF86MonBrightnessDown".spawn-sh = "brightnessctl --class=backlight set 10%-";
        };
      };
    };
  };
}
