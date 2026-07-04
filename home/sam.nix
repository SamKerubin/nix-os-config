{ config, pkgs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/kitty.nix
  ];

  home.username = "sam";
  home.homeDirectory = "/home/sam";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    lsd
    wget
    tree
    htop
    btop
    fastfetch

    neovim

    wget
    curl
    unzip
    zip
    jq

    alacritty
    kitty

    obsidian
    spotify
    discord
    vinegar
    flatpak
    steam
    steam-run

    github-desktop
    github-cli
    yq
    fzf
    zoxide
    lazygit
    rofi
    wlogout
    nautilus
    gvfs

    python3
    python314Packages.pip
    nodejs
    yarn
    jdk
    maven
    cmake
    gnumake
    gcc
    findutils
    coreutils
    meson
    ninja
    # clang
    llvm
    valgrind
    bear
    gdb
    clang-tools

    grim
    slurp
    wl-clipboard
    cliphist
    brightnessctl
    libnotify
    pavucontrol
    blueman

    ranger
    trash-cli
    obs-studio
    vlc
    imagemagick
    ffmpeg
    mpv

    noto-fonts
    fira-code
    jetbrains-mono
  ];
 
  programs.alacritty.enable = true;

  services = {
    dunst = {
      enable = true;
      settings = {
        global = {
          font = "JetBrains Mono 10";
          geometry = "300x5-30+20";
          frame_width = 1;
        };
      };
    };
  };
}
