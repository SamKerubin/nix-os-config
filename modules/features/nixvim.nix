{ self, inputs, ... }: {
  flake.nixosModules.nixvim = { config, pkgs, ... }: {
    imports = [
      inputs.nixvim.nixosModules.nixvim
    ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      plugins = {
        lualine.enable = true;
        telescope.enable = true;
      };

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavor = "mocha";
        };
      };

      opts = {
        number = true;
        relativenumber = true;
        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;
        smartindent = true;
        autoindent = true;
        wrap = false;
        hlsearch = true;
        incsearch = true;
        termguicolors = true;
        autoformat = false;
      };

      extraFiles = {
        "ftplugin/c.lua".text = ''
          vim.bo.tabstop = 4;
          vim.bo.shifwidth = 4;
          vim.bo.softtabstop = 4;
        '';
      };
    };
  };
}
