{ pkgs, inputs, ... }: {
  # imports = [
  #   self.nixosModules.samHardware
  #   self.nixosModules.niri
  #   self.nixosModules.homeManager
  #   self.nixosModules.nixvim
  # ];

  zramSwap.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;

  time.timeZone = "America/Bogota";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  services.xserver.enable = true;
  #
  # services.displayManager = {
  #   sddm = {
  #     enable = true;
  #     wayland = {
  #       enable = true;
  #       compositor = "kwin";
  #     };
  #
  #     package = pkgs.kdePackages.sddm;
  #
  #     extraPackages = with pkgs; [
  #       kdePackages.qtsvg
  #       kdePackages.qtmultimedia
  #       kdePackages.qtvirtualkeyboard
  #     ];
  #
  #     theme = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";
  #   };
  # };
  #
  # services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };

  console.keyMap = "la-latin1";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users."sam" = {
    isNormalUser = true;
    description = "sam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # kdePackages.kate
    ];
    shell = pkgs.zsh;
  };

  services.flatpak.enable = true;
  services.upower.enable = true;

  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;
  programs.zsh.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    glib
    openssl
    curl
    icu
    libxml2

    gtk2
    gtk3
    gtk4
    nss
    nspr
    dbus
    libGL
    libva
  ];

  documentation = {
    enable = true;
    dev.enable = true;
    man.generateCaches = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-oldern-than 7d";
  };

  nix.settings.auto-optimise-store = true;
  nix.settings.max-jobs = 2;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
 
  system.autoUpgrade = {
    enable = true;
    flake = "/home/sam/nix-os-config/#sam";
    flags = [ "--update-input" "nixpkgs" "--print-build-logs" ];
    dates = "0 1 * * *";
    runGarbageCollection = true;
  }; 

  systemd.coredump.settings.Coredump = {
    Storage = "external";
    Compress = "no";
  }; 

  system.stateVersion = "26.05";
}
