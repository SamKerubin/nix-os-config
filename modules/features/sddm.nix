{ inputs, ... }: {
  flake.nixosModules.sddm = { config, pkgs, ... }: 
  let
    custom-astronaut = pkgs.sddm-astronaut.override {
      embeddedTheme = "black_hole";
      themeConfig = {
        Background = toString ../../home/programs/assets/bg/bg6.png;
        FormPosition = "center";
        FontSize = "12";
        Font = "Noto Sans";

        PartialBlur = "true";
        BlurMax = "35";
        Blur = "2.0";
        HaveFormBackground = "true";
      };
    };
  in {
    environment.systemPackages = [
      custom-astronaut
      pkgs.kdePackages.qtmultimedia
      pkgs.kdePackages.qtsvg
      pkgs.kdePackages.qtvirtualkeyboard
    ];

    services.displayManager = {
      sddm = {
        enable = true;
        #
        # wayland = {
        #   enable = true;
        #   compositor = "kwin";
        # };
        #
        package = pkgs.kdePackages.sddm;

        theme = "${custom-astronaut}/share/sddm/themes/sddm-astronaut-theme";

        extraPackages = [
          custom-astronaut
          pkgs.kdePackages.qtsvg
          pkgs.kdePackages.qtmultimedia
          pkgs.kdePackages.qtvirtualkeyboard
        ];
      };
    };
  };
}
