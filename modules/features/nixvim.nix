{ self, inputs, ... }: {
  flake.nixosModules.nixvim = { config, pkgs, ... }: {
    imports = [
      inputs.nixvim.nixosModules.nixvim
    ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      keymaps = [
        {
          mode = "n";
          key = "<Space>";
          action = "<Nop>";
          options.silent = true;
        }
      ];

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      plugins = {
        telescope = {
          enable = true;
          extensions = {
            fzf-native = {
              enable = true;
            };
          };
        };

        treesitter = {
          enable = true;
  
          grammarPackages = config.programs.nixvim.plugins.treesitter.package.passthru.allGrammars;
          
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };

        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
              { name = "luasnip"; }
            ];
            mapping = {
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-e>" = "cmp.mapping.abort()";
              "<CR>" = "cmp.mapping.confirm({select = true})";
              "<S-CR>" = "cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})";
            };
          };
        };

        # neotree = {
        #   enable = true;
        #   settings = {
        #     close_if_last_window = true;
        #     popup_border_style = "rounded";
        #   };
        # };

        lsp = {
          enable = true;
          servers = {
            clangd = {
              enable = true;
              settings = {
                cmd = [ "clangd" "--background-index" "--clang-tidy" ];
              };
            };

            lua_ls.enable = true;
            pyright.enable = true;
            rust_analyzer.enable = true;
            jsonls.enable = true;
            yamlls.enable = true;
            marksman.enable = true;
            nixd.enable = true;
            jdtls.enable = true;
            ts_ls.enable = true;
            vtsls.enable = true;
            bashls.enable = true;
          };
        };

        indent-blankline = {
          enable = true;
          settings = {
            indent = {
              char = "│";
              tab_char = "│";
            };
            scope = {
              enabled = true;
              show_start = true;
              show_end = true;
            };
          };
        };

        noice = {
          enable = true;
          settings = {
            lsp = {
              override = {
                "vim.lsp.util.convert_input_to_markdown_lines" = true;
                "vim.lsp.util.stylize_markdown" = true;
                "cmp.entry.get_documentation" = true;
              };
            };
            presets = {
              bottom_search = true;
              command_palette = true;
              long_message_to_split = true;
              inc_rename = true;
            };
          };
        };

        # mason.enable = true;
        luasnip.enable = true;
        bufferline.enable = true;
        which-key.enable = true;
        gitsigns.enable = true;
        nvim-autopairs.enable = true;
        todo-comments.enable = true;
        conform-nvim.enable = true;
        lint.enable = true;
        web-devicons.enable = true;
      };

      extraPlugins = with pkgs.vimPlugins; [
        comment-nvim
        neo-tree-nvim
      ];

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavor = "mocha";
        };
      };

      opts = {
        number = true;
        relativenumber = true;
        clipboard = "unnamedplus";
        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;
        smartindent = true;
        autoindent = true;
        wrap = false;
        hlsearch = true;
        incsearch = true;
        termguicolors = true;
        # autoformat = false;
        mouse = "a";
        signcolumn = "yes";
        updatetime = 50;
        timeoutlen = 300;
        splitright = true;
        splitbelow = true;
      };

      extraConfigLua = ''
        vim.g.mapleader = " "
        vim.g.maplocalleader = " "

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {desc = "Go to Definition"})
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {desc = "Hover"})
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {desc = "Rename"})
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {desc = "Code action"})
        vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", {desc = "File explorer"})
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {desc = "Find files"})
        vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {desc = "Search text"})
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {desc = "List buffers"})
        vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {desc = "Help"})
        vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", {desc = "Save"})
        vim.keymap.set("n", "<C-h>", "<C-w>h", {desc = "Move left"})
        vim.keymap.set("n", "<C-j>", "<C-w>j", {desc = "Move down"})
        vim.keymap.set("n", "<C-k>", "<C-w>k", {desc = "Move up"})
        vim.keymap.set("n", "<C-l>", "<C-w>l", {desc = "Move right"})
        vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", {desc = "Save"})
        vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", {desc = "Close"})
        vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", {desc = "Close buffer"})
        vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#<CR>", {desc = "Close other buffers"})
        vim.keymap.set("n", "<leader>b]", "<cmd>bnext", {desc = "Go to next buffer"})
        vim.keymap.set("n", "<leader>b[", "<cmd>bprev", {desc = "Go to previous buffer"})

        require("telescope").load_extension("fzf")
        require("neo-tree").setup({})
        require("Comment").setup()
      '';

      extraFiles = {
        "ftplugin/c.lua".text = ''
          vim.bo.tabstop = 4;
          vim.bo.shiftwidth = 4;
          vim.bo.softtabstop = 4;
        '';
      };
    };
  };
}
