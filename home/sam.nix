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
        steam-path=~/.local/share/Steam/ubuntu12_64/steamwebhelper
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
        ranger --choosedir=$home/.rangerdir
        lastdir=`cat $home/.rangerdir`
        cd "$lastdir" && notify-send "changed to $(pwd)" || notify-send "something failed"; exit
        nvim
      '';
    })
  ];

  programs.alacritty.enable = true;
}
