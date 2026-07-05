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

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

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
    figlet

    # neovim

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
    cargo
    rustc
    nil

    grim
    slurp
    wl-clipboard
    cliphist
    brightnessctl
    libnotify
    pavucontrol
    blueman
    playerctl

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
    meslo-lgs-nf

    (pkgs.writeShellApplication {
      name = "enable-steam";
      text = ''
        steam_path=~/.local/share/Steam/ubuntu12_64/steamwebhelper
        enable=$1
        if (( enable == 1  )); then
          sudo chattr -i $steam_path
          sudo chmod a+x $steam_path
        fi
        if (( enable == 0  )); then
          sudo chmod a-x $steam_path
          sudo chattr +i $steam_path
          sudo pkill -9 steamwebhelper
        fi
      '';
    })

    (pkgs.writeShellApplication {
      name = "open-nvim";
      text = ''
        ranger --choosedir="$HOME/.rangerdir"
        lastdir=$(cat "$HOME/.rangerdir")
        cd "$lastdir" || exit
        notify-send "changed to $(pwd)" 
        nvim
      '';
    })
  ];

  programs.alacritty.enable = true;
}
