return require 'packer'.startup(function(use)
	-- Packer is stupid so i have to have it here too
	use 'wbthomason/packer.nvim'

	use({
		'rose-pine/neovim',
		as = 'rose-pine',
    tag = 'v1.*'
	})

  use "VDuchauffour/neodark.nvim"

  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
   }

  --[[use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
   }]]

  use 'rktjmp/lush.nvim'

	use 'preservim/nerdcommenter'

 	use {'kyazdani42/nvim-tree.lua',
 	config = function()
		require 'nvim-tree'.setup {
			--auto_close = true,
			update_cwd = true,
			diagnostics = {
				enable = true,
			},
			update_focused_file = {
				enable = true,
			},
			filters = {
				custom = {'.git', 'node_modules'}
			},
			view = {
				width = 30,
			}
		}
	end
	}

	use {'nvim-telescope/telescope.nvim', requires = {'kyazdani42/nvim-web-devicons', 'nvim-lua/plenary.nvim'}}

	use {'nvim-treesitter/nvim-treesitter',
		config = function()
			require 'nvim-treesitter.configs'.setup {
				ensure_installed = {'lua', 'go', 'c', 'cpp', 'rust', 'javascript', 'typescript', 'fish', 'dockerfile', 'gomod', 'json', 'elixir', 'php', 'tsx', 'haskell', 'dart', 'commonlisp'},
				highlight = {
					enable = true,
          additional_vim_regex_highlighting = {'org'},
				},
  			autotag = {
    			enable = true,
  			},
  			auto_install = true
			}
		end
	}

  --use {'nvim-orgmode/orgmode',
    --after = "nvim-treesitter",
    --config = function()
      --require('orgmode').setup_ts_grammar()

      --require('orgmode').setup({
        --org_agenda_files = {'~/org/*', '~/orgs/**/*'},
        --org_default_notes_file = '~/org/refile.org',
        --mappings = {
          --global = {
            --org_agenda = 'gA',
            --org_capture = 'gC'
          --}
        --}
      --})
    --end
  --}

	use {'windwp/nvim-autopairs',
		config = function()
 			require 'nvim-autopairs'.setup{}
		end
	}

	use 'lewis6991/impatient.nvim'

	use {'andweeb/presence.nvim',
	 	 event = 'BufRead',
	 	 config = function()
		 	 require 'presence':setup {
			 	 auto_update	= true,
			 	 neovim_image_text = 'The One True Text Editor',
			 	 main_image = 'file',
			 	 log_level = 'error',
			 	 debounce_timeout = 10,
			 	 enable_line_number	= false,
			 	 editing_text = 'Working on %s',
			 	 file_explorer_text	= 'Browsing %s',
			 	 git_commit_text = 'Committing Changes',
			 	 plugin_manager_text = 'Managing Plugins',
			 	 reading_text = 'Looking at %s',
			 	 workspace_text = 'Workspace: %s',
			 	 line_number_text = 'Line %s/%s',
		 	 }
	 	 end
	}

	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'

	use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'tami5/lspsaga.nvim'
	use 'folke/lsp-colors.nvim'

	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/vim-vsnip'

 use 'nvim-lua/lsp-status.nvim'

 use {'folke/trouble.nvim', requires = 'kyazdani42/nvim-web-devicons'}

	--use 'L3MON4D3/LuaSnip'
	--use 'saadparwaiz1/cmp_luasnip'

	--use 'SirVer/ultisnips'
	--use 'quangnguyen30192/cmp-nvim-ultisnips'

	--use 'fatih/vim-go'
	use 'rust-lang/rust.vim'

	--use {'gbprod/cutlass.nvim',
		--config = function()
			--require 'cutlass'.setup {
				--cut_key = 'x'
			--}
		--end
	--}

 use 'mg979/vim-visual-multi'

 use 'wakatime/vim-wakatime'

 use {
   "ray-x/lsp_signature.nvim",
 }

 use 'airblade/vim-gitgutter'

 use 'styled-components/vim-styled-components'

 --use { 'neoclide/coc.nvim', branch = 'release'}

 use 'APZelos/blamer.nvim'

 use {
   "folke/todo-comments.nvim",
   requires = "nvim-lua/plenary.nvim",
   config = function()
     require("todo-comments").setup {
       -- your configuration comes here
       -- or leave it empty to use the default settings
       -- refer to the configuration section below
     }
   end
 }

  use { 'sbdchd/neoformat' }

  use {'ShinKage/idris2-nvim', requires = {'neovim/nvim-lspconfig', 'MunifTanjim/nui.nvim'}}

  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

--use "lukas-reineke/indent-blankline.nvim"

  use {'norcalli/nvim-colorizer.lua'}

  use 'tpope/vim-surround'

  use 'mattn/emmet-vim'

  use 'voldikss/vim-floaterm'

  use 'alvan/vim-closetag'

  use 'ray-x/go.nvim' -- remember later

  use 'karb94/neoscroll.nvim'

  use {
    "windwp/nvim-ts-autotag"
  }
  use 'phaazon/mind.nvim'

  use 'kyazdani42/nvim-web-devicons'

  use 'xiyaowong/nvim-transparent'

  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

  use {
    'synaptiko/xit.nvim',
    opt = true, -- for lazy-loading
    ft = 'xit', -- for lazy-loading
    run = function(plugin)
      plugin.config()
      vim.cmd[[:TSInstall! xit]]
    end,
    config = function() require('xit').setup() end,
    requires = { 'nvim-treesitter/nvim-treesitter' }
  }

  use { 'm4xshen/hardtime.nvim', requires = {'MunifTanjim/nui.nvim'}, config = function () require("hardtime").setup() end }

  use { 'vlime/vlime', rtp = 'vim/'}

  --use({
  --"epwalsh/obsidian.nvim",
  --tag = "*",  -- recommended, use latest release instead of latest commit
  --requires = {
    ---- Required.
    --"nvim-lua/plenary.nvim",

    ---- see below for full list of optional dependencies 👇
  --},
  --config = function()
    --require("obsidian").setup({
      --workspaces = {
        --{
          --name = "personal",
          --path = "~/obsidian-vaults/personal-vault",
        --},
      --},
      ---- see below for full list of options 👇
    --})
  --end,
--})
--use ({
    --"nvzone/typr",
    --requires = {
      --"nvzone/volt"
    --},
    --opts = {},
    --cmd = { "Typr", "TyprStats" },
--})

end)
