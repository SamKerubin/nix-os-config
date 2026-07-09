{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
    };

    initExtraFirst = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      eval "$(direnv hook zsh)"
    '';

    initContent = ''
      test -f ~/.p10k.zsh && source ~/.p10k.zsh
    '';
    shellAliases = {
      os-test = "sudo nixos-rebuild test --flake ~/nix-os-config#sam";
      os-rebuild = "sudo nixos-rebuild switch --flake ~/nix-os-config#sam";
      os-update = "cd ~/nix-os-config && nix flake update; cd - && sudo nixos-rebuild switch --flake ~/nix-os-config#sam";
      os-gen-clean = "sudo nix-collect-garbage -d && sudo nixos-rebuild switch --flake ~/nix-os-config#sam";
      os-boot = "sudo nixos-rebuild boot --flake ~/nix-os-config#sam";

      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";

      cat = "bat";
      grep = "rg";
      nano = "nvim";
      ls = "lsd -alh --color=auto";

      en0 = "enable-steam 0";
      en1 = "enable-steam 1";
      ipinfo = "ip -c a";

      make-corefiles-dir="mkdir -p /tmp/corefiles && chmod 1777 /tmp/corefiles";
    };
  };
}

