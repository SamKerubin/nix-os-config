{ inputs, ... }: {
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
    
        lsp = {
          enable = true;
          servers = {
            clangd = {
              enable = true;
              settings = {
                cmd = [ "clangd" "--background-index" "--clang-tidy" ];
              };
            };

            rust_analyzer = {
              enable = true;
              settings = {
                inlayHints = {
                  parameterHints = {
                    enable = true;
                  };
                  typeHints = {
                    enable = true;
                    hideClosureInitialization = false;
                    hideNamedConstructor = false;
                  };
                  chainingHints = {
                    enable = true;
                  };
                  lifetimeElisionHints = {
                    enable = "always"; 
                    useParameterNames = true;
                  };
                  closingBraceHints = {
                    enable = true;
                    minLength = 25;
                  };
                  bindingModeHints = {
                    enable = true;
                  };
                  reborrowHints = {
                    enable = "always";
                  };
                  renderColons = true;
                };
              };
            };

            lua_ls.enable = true;
            pyright.enable = true;
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
        snacks-nvim
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
        mouse = "a";
        signcolumn = "yes";
        updatetime = 50;
        timeoutlen = 300;
        splitright = true;
        splitbelow = true;
      };

      extraConfigLua = ''
        -- Leader
        vim.g.mapleader = " "
        vim.g.maplocalleader = " "

        -- Windows
        vim.keymap.set("n", "<C-h>", "<C-w>h", {desc = "Focus left"})
        vim.keymap.set("n", "<C-j>", "<C-w>j", {desc = "Focus down"})
        vim.keymap.set("n", "<C-k>", "<C-w>k", {desc = "Focus up"})
        vim.keymap.set("n", "<C-l>", "<C-w>l", {desc = "Focus right"})

        -- Buffers
        vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", {desc = "Close buffer"})
        vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#<CR>", {desc = "Close other buffers"})
        vim.keymap.set("n", "<leader>b]", "<cmd>bnext<CR>", {desc = "Go to next buffer"})
        vim.keymap.set("n", "<leader>b[", "<cmd>bprev<CR>", {desc = "Go to previous buffer"})
        vim.keymap.set("n", "<leader>bk", "<cmd>BufferLineMoveNext<CR>", {desc = "Move buffer right"})
        vim.keymap.set("n", "<leader>bj", "<cmd>BufferLineMovePrev<CR>", {desc = "Move buffer left"})

        -- Select 
        vim.keymap.set("v", ">", ">gv", {desc = "Indent"})
        vim.keymap.set("v", "<", "<gv", {desc = "Unindent"})

        -- Files
        vim.keymap.set("n", "<C-s>", "<cmd>wa<CR>", {desc = "Save all"})
        vim.keymap.set("i", "<C-s>", "<cmd>wa<CR>", {desc = "Save all (insert)"})
        vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", {desc = "Save"})
        vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", {desc = "Close"})
        vim.keymap.set("n", "<leader>Q", "<cmd>qa<CR>", {desc = "Close all"})

        -- LSP
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {desc = "Go to definition"})
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {desc = "Go to declaration"})
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {desc = "Hover"})
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {desc = "Signature help"})
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {desc = "Rename"})
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {desc = "Code action"})
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {desc = "Open diagnostic"})
        vim.keymap.set("n", "<leader>d]", vim.diagnostic.goto_next, {desc = "Prev diagnostic"})
        vim.keymap.set("n", "<leader>d[", vim.diagnostic.goto_prev, {desc = "Next diagnostic"})

        -- Neotree
        vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", {desc = "File explorer"})
        
        -- Telescope
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {desc = "Find files"})
        vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {desc = "Search text"})
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {desc = "List buffers"})
        vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {desc = "Help"})
        vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", {desc = "Recent files"})
        vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", {desc = "Git status"})
        vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", {desc = "Git commits"})

        -- Git
        vim.keymap.set("n", "<leader>h]", "<cmd>lua require('gitsigns').next_hunk()<CR>", {desc = "Next hunk"})
        vim.keymap.set("n", "<leader>h[", "<cmd>lua require('gitsigns').prev_hunk()<CR>", {desc = "Prev hunk"})

        -- Conform 
        vim.keymap.set("n", "<leader>F", "<cmd>lua require('conform').format({async = true})<CR>", {desc = "Format file"})

        -- Noice 
        vim.keymap.set("n", "<Esc>", "<cmd>NoiceDismiss<CR>", {desc = "Dismiss notification"})

        -- Todo 
        vim.keymap.set("n", "t]", "<cmd>lua require('todo-comments').jump_next()<CR>", {desc = "Go to next TODO"})
        vim.keymap.set("n", "t[", "<cmd>lua require('todo-comments').jump_perv()<CR>", {desc = "Go to prev TODO"})
        
        -- Terminal
        vim.keymap.set("n", "<leader>ft", function() local cwd = vim.fn.getcwd(); vim.fn.jobstart({"kitty", "--class", "nvim-terminal", "--directory", cwd}); end, {desc = "Open terminal"})

        -- Inlay hints
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then return end

            if client.supports_method("textDocument/inlayHint") then
              vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
            else
              vim.api.nvim_create_autocmd("User", {
                pattern = "LspDynamicCapabilityChange",
                callback = function()
                  if client.supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                  end
                end,
              })
            end
          end,
        })

        vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#888888", italic = true })

        require("telescope").load_extension("fzf")
        require("neo-tree").setup({})
        require("Comment").setup()

        require("snacks").setup({
          dashboard = {
            enabled = true,
            preset = {
              header = [[
                                                        ░██                        ░██████  
                                                                                  ░██   ░██ 
░█████████████   ░███████  ░██    ░██    ░██ ░██    ░██ ░██░█████████████               ░██ 
░██   ░██   ░██ ░██    ░██ ░██    ░██    ░██ ░██    ░██ ░██░██   ░██   ░██    ░██   ░█████  
░██   ░██   ░██ ░█████████  ░██  ░████  ░██   ░██  ░██  ░██░██   ░██   ░██              ░██ 
░██   ░██   ░██ ░██          ░██░██ ░██░██     ░██░██   ░██░██   ░██   ░██        ░██   ░██ 
              ░██   ░██   ░██  ░███████     ░███   ░███       ░███    ░██░██   ░██   ░██    ░██  ░██████                

              ]],
            },
            sections = {
              { section = "header" },
              { section = "projects", title = "Projects", padding = 1 },
              { section = "recent_files", title = "Recent files", padding = 1 },
            },
          },
          picker = {
            enabled = true
          },
        })
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
