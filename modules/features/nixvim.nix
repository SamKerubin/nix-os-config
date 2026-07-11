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
            snippet.expand = config.lib.nixvim.mkRaw "function(args) require('luasnip').lsp_expand(args.body) end";
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
              { name = "luasnip"; }
            ];
            mapping = {
              "<C-b>" = config.lib.nixvim.mkRaw "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = config.lib.nixvim.mkRaw "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = config.lib.nixvim.mkRaw "cmp.mapping.complete()";
              "<C-e>" = config.lib.nixvim.mkRaw "cmp.mapping.abort()";
              "<CR>" = config.lib.nixvim.mkRaw "cmp.mapping.confirm({select = true})";
              "<S-CR>" = config.lib.nixvim.mkRaw "cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})";

              "<Tab>" = config.lib.nixvim.mkRaw ''cmp.mapping(function(fallback)
                local cmp = require("cmp")
                local luasnip = require("luasnip")

                local has_words_before = function()
                  unpack = unpack or table.unpack
                  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                end

                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumped() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                end
              end, {"i", "s"})
              '';

              "<S-Tab>" = config.lib.nixvim.mkRaw ''cmp.mapping(function(fallback)
                local cmp = require("cmp")
                local luasnip = require("luasnip")

                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, {"i", "s"})
              '';
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
            neocmake.enable = true;
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
        
        direnv = {
          enable = true;
          settings = {
            silent = true;
          };
        };
  
        luasnip = {
          enable = true;
          fromVscode = [ {} ];
        };

        friendly-snippets.enable = true;
        cmp_luasnip.enable = true;
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

        -- Line movement 
        vim.keymap.set({"n", "v"}, "gh", "0", {desc = "Move to start of the line"});
        vim.keymap.set({"n", "v"}, "gl", "$", {desc = "Move to end of the line"});
        vim.keymap.set("n", "<leader>vgh", "v0", {desc = "Select to the start of the line"})
        vim.keymap.set("n", "<leader>vgl", "v$", {desc = "Select to the end of the line"})

        -- Get into normal mode
        vim.keymap.set({"i", "v"}, "<C-c>", "<Esc>", {desc = "Get out insert/visual mode"})

        -- Navigation
        vim.keymap.set("n", "n", "nzzzv", {desc = "Search next match"})
        vim.keymap.set("n", "N", "Nzzzv", {desc = "Search prev match"})
        vim.keymap.set("n", "*", "*zz", {desc = "Search next match"})
        vim.keymap.set("n", "#", "#zz", {desc = "Search prev match"})
        vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc = "Page down"})
        vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc = "Page up"})
        vim.keymap.set("n", "{", "{zz", {desc = "Prev paragraph"})
        vim.keymap.set("n", "}", "}zz", {desc = "Next paragraph"})
        vim.keymap.set("n", "j", "jzz", {desc = "Move down"})
        vim.keymap.set("n", "k", "kzz", {desc = "Move up"})

        -- Undo/Redo
        vim.keymap.set("n", "u", "uzzzv", {desc = "Undo"})
        vim.keymap.set("n", "<C-r>", "<C-r>zz", {desc = "Redo"})

        -- Search
        vim.keymap.set("n", "-", "/", {desc = "Search pattern"})

        -- Search-Replace
        vim.keymap.set("n", "<leader>sr", function()
            local word = vim.fn.expand("<cword>")
            local escaped = vim.fn.escape(word, "/\\")
            local cmd = ":%s/" .. escaped .. "//g"
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes(cmd .. "<Left><Left>", true, false, true),
                "m", true
            )
        end, {desc = "Search and replace word under cursor"})

        -- Select quotes
        local function quote_motion(op)
            return function()
                local keys = op .. "/['\"`]/<CR>:nohlsearch<CR>"
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes(keys, true, false, true),
                    "m", true
                )
            end
        end
        vim.keymap.set("n", "dq", quote_motion("d"), {desc = "Delete up to next quote"})
        vim.keymap.set("n", "yq", quote_motion("y"), {desc = "Yank up to next quote"})
        vim.keymap.set("n", "cq", quote_motion("di"), {desc = "Change up to next quote"})

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
        vim.keymap.set({"n", "i"}, "<C-s>", "<cmd>wa<CR>", {desc = "Save all"})
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
        vim.keymap.set("n", "<leader>t]", "<cmd>lua require('todo-comments').jump_next()<CR>", {desc = "Go to next TODO"})
        vim.keymap.set("n", "<leader>t[", "<cmd>lua require('todo-comments').jump_perv()<CR>", {desc = "Go to prev TODO"})
        
        -- Terminal
        vim.keymap.set("n", "<leader>ft", function()
          local cwd = vim.fn.getcwd()
          vim.fn.jobstart({"kitty", "--class", "nvim-terminal", "--directory", cwd})
        end, {desc = "Open terminal"})

        -- Inlay hints
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then return end

            if client:supports_method("textDocument/inlayHint") then
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

        -- Line highlighting
        vim.opt.cursorline = true
        vim.opt.cursorlineopt = "number"
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f7cfe2", bold = true })

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
