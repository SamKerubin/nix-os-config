{ pkgs, ... }: {
  programs.git = {
    enable = true;

    settings = {
      user.name = "SamKerubin";
      user.email = "sammm.1618033@gmail.com";

      alias = {
        a = "commit --amend";
        cam = "commit -am";
        cm = "commit -m";
        co = "checkout";
        br = "branch";
        amend = "commit --amend --no-edit";
        s = "status";
        unstage = "reset HEAD --";
        uncommit = "reset --soft HEAD^";
        discard = "reset HEAD --hard";
        discardchunk = "checkout -p";
        fixup = "!git log --oneline --decorate @{u}.. | fzf | awk '{ print $1 }' | xargs -r git commit --fixup={}";
        rb = "rebase -i";
        squash = "rebase -i --autosquash";
        last = "log -1 HEAD";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };

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
