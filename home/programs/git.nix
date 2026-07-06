{ pkgs, ... }: {
  programs.git = {
    enable = true;

    userName = "SamKerubin";
    userEmail = "samuelkiller2013@gmail.com";

    aliases = {
      co = "checkout";
      br = "branch";
      cm = "commit";
      st = "status";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };

    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
        autocrlf = "input";
      };

      pull.rebase = true;
      rebase.autoStash = true;
      push.autoSetupRemote = true;
      color.ui = true;
    };
  };
}
