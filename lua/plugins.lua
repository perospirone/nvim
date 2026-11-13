return {
  -- Theme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    version = "^1", -- theme.lua uses the v1 API (dark_variant, groups)
    lazy = false,
    priority = 1000,
    config = function()
      require("theme")
    end,
  },
  { "xiyaowong/nvim-transparent",  lazy = false },

  -- Statusline / icons
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lualine/lualine.nvim",   dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeRefresh", "NvimTreeFindFile" },
    config = function()
      require("nvim-tree").setup({
        sync_root_with_cwd = true,
        diagnostics = { enable = true },
        update_focused_file = { enable = true },
        filters = { custom = { ".git", "node_modules" } },
        view = { width = 30 },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- the `master` branch is locked to Neovim <= 0.11 and its
    lazy = false,    -- configs.setup() API no longer exists here
    build = ":TSUpdate",
    config = function()
      require("treesitter")
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Editing helpers
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  "tpope/vim-surround",
  "mattn/emmet-vim",
  "alvan/vim-closetag",
  "preservim/nerdcommenter",
  { "karb94/neoscroll.nvim", lazy = false, config = function() require("neoscroll").setup() end },
  {
    "norcalli/nvim-colorizer.lua",
    lazy = false,
    config = function()
      require("colorizer").setup({ "*", css = { rgb_fn = true } })
    end
  },

  -- LSP + completion
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "ray-x/lsp_signature.nvim",
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          "hrsh7th/cmp-vsnip",
          "hrsh7th/vim-vsnip",
        },
      },
    },
    config = function()
      require("lsp")
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonLog", "MasonUpdate" },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "gopls", "clangd", "zls", "ts_ls", "phpactor", "dartls",
        "eslint", "tailwindcss", "lua_ls", "rust_analyzer", "pyright", "jsonls",
        "html", "cssls",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal", winbar_info = false },
        file_history = { layout = "diff2_horizontal", winbar_info = false },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { position = "left", width = 32 },
      },
    },
  },

  -- Formatting
  { "sbdchd/neoformat",       cmd = "Neoformat" },

  -- Git
  {
    -- async hunks and blame; replaces vim-gitgutter + blamer, which shelled out
    -- to git on cursor movement and on every write
    "lewis6991/gitsigns.nvim",
    -- eager: on BufReadPre the plugin's attach autocmds are registered too late
    -- for the first buffer opened from the command line
    lazy = false,
    config = function()
      require("gitsigns").setup({
        current_line_blame = false, -- on demand with <leader>tb
        current_line_blame_opts = { delay = 500, virt_text_pos = "eol" },
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("n", "]c", function() gs.nav_hunk("next") end, "next hunk")
          map("n", "[c", function() gs.nav_hunk("prev") end, "previous hunk")
          map("n", "<leader>hp", gs.preview_hunk, "preview hunk")
          map("n", "<leader>hs", gs.stage_hunk, "stage hunk")
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, "stage selection")
          map("n", "<leader>hr", gs.reset_hunk, "reset hunk")
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "blame line")
          map("n", "<leader>hd", gs.diffthis, "diff this file")
          map("n", "<leader>tb", gs.toggle_current_line_blame, "toggle line blame")
        end,
      })
    end,
  },

  -- Misc
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {},
  },
  { "voldikss/vim-floaterm", cmd = { "FloatermNew", "FloatermToggle", "FloatermKill" } },
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("hardtime").setup()
    end
  },
  -- Discord RPC only loads when the Discord socket exists, otherwise it retries
  -- and logs errors on every start
  {
    "andweeb/presence.nvim",
    event = "BufRead",
    cond = function()
      return vim.uv.fs_stat("/run/user/" .. vim.uv.getuid() .. "/discord-ipc-0") ~= nil
    end,
    config = function()
      require("presence").setup({
        auto_update = true,
        neovim_image_text = "The One True Text Editor",
        main_image = "file",
        log_level = "error",
        debounce_timeout = 10,
        enable_line_number = false,
        editing_text = "Working on %s",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing Changes",
        plugin_manager_text = "Managing Plugins",
        reading_text = "Looking at %s",
        workspace_text = "Workspace: %s",
        line_number_text = "Line %s/%s",
      })
    end
  },

  -- Language specific
  { "ray-x/go.nvim",         ft = { "go", "gomod", "gosum", "gohtmltmpl" },            config = function() require("go")
        .setup() end },
  "rust-lang/rust.vim",
  { "ShinKage/idris2-nvim", dependencies = { "neovim/nvim-lspconfig", "MunifTanjim/nui.nvim" } },
  {
    "vlime/vlime",
    -- vlime keeps its runtime files in a vim/ subdirectory (packer's rtp option,
    -- which lazy.nvim does not have)
    init = function()
      vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/vlime/vim")
    end,
  },

  -- Notes
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
  },
}
