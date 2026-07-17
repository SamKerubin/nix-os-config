{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 12;
    };

    themeFile = "Catppuccin-Mocha";

    settings = {
      background_opacity = "0.7";
      background_blur = "1";
      confirm_os_window_close = "0";
      enable_audio_bell = "no";
      cursor_shape = "block";
      shell_integration = "enabled";
    };
  };
}
