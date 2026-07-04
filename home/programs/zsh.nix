{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "powerlevel10k/powerlevel10k";
    };
    initContent = ''
      test -f ~/.p10k.zsh && source ~/.p10k.zsh
    '';
    shellAliases = {
      ls = "lsd -alh --color=auto";
      os-rebuild = "sudo nixos-rebuild switch --flake ~/nix-os-config#sam";
      os-update = "sudo nixos-rebuild switch --flake ~/nix-os-config/#sam --upgrade";

      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";

      cat = "bat";
      grep = "rg";
    };
  };
}



