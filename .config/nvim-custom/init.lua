-- options
vim.opt.number = true
vim.opt.shell = '/bin/zsh'
vim.opt.path = { '**' }
vim.opt.wildignore = { '*/node_modules/*', '*/cache/*', '*/tmp/*' }

vim.opt.foldmethod = 'indent'
vim.opt.foldnestmax = 10
vim.opt.foldenable = false
vim.opt.foldlevel = 1

vim.opt.wrapscan = true       -- wrap searches around top/bottom of file
vim.opt.writebackup = false   -- no tilde files
vim.opt.switchbuf = 'useopen' -- use an already open window if possible
vim.opt.splitright = true     -- open vsplits in a more natural spot
vim.opt.textwidth = 80        -- wrap lines
vim.opt.scrolloff = 5         -- start scrolling when within 6 lines near the top/bottom
vim.opt.autoindent = true
-- vim.opt.cursorline = true
vim.opt.wildmenu = true

-- Set the behavior of tab
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
-- limit CursorLine length
-- otherwise it will slow down editing
vim.opt.synmaxcol = 200

-- vim.opt.autochdir = true

-- colours and fonts
vim.opt.termguicolors = true
vim.cmd('syntax enable')
vim.cmd('filetype plugin on')
vim.cmd([[
  augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
  augroup END
]])

-- vim.g.copilot_node_command = '~/.nodenv/versions/17.9.1/bin/node'
vim.g.copilot_node_command = '~/.nodenv/versions/20.5.0/bin/node'

-- Ensure packer is installed and initialized
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end


-- Function to dynamically set the Ruby host program for Neovim
function set_ruby_host_prog()
  -- The command to find the neovim-ruby-host executable within the bundle
  local command = "bundle exec which neovim-ruby-host"

  -- Execute the command and store the output (path to neovim-ruby-host)
  local neovim_ruby_host_path = vim.fn.trim(vim.fn.system(command))

  -- Check if the command was successful (path is not empty)
  if neovim_ruby_host_path ~= "" then
    -- Set the global variable for the Ruby host program
    vim.g.ruby_host_prog = neovim_ruby_host_path
  else
    -- Optionally, handle the case where neovim-ruby-host is not found
    print("neovim-ruby-host not found in the current bundle.")
  end
end

-- Call the function to set the Ruby host program
set_ruby_host_prog()



require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer manages itself
  use "williamboman/mason.nvim"
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'kyazdani42/nvim-web-devicons'
  use 'tmux-plugins/vim-tmux'
  use 'fladson/vim-kitty'
  use 'bluz71/vim-moonfly-colors'
  use 'airblade/vim-gitgutter'
  use 'nvim-lua/popup.nvim'
  use 'norcalli/nvim-colorizer.lua'
  use 'styled-components/vim-styled-components'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'pangloss/vim-javascript'
  use 'jonsmithers/vim-html-template-literals'
  use 'lewis6991/gitsigns.nvim' -- OPTIONAL: for git status
  use 'romgrk/barbar.nvim'
  use({
    'nvimdev/lspsaga.nvim',
    after = 'nvim-lspconfig',
    config = function()
      require('lspsaga').setup({})
    end,
  })

  use({
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })

  use {
    'github/copilot.vim',
    config = function()
      -- Optional: Configuration settings for Copilot can go here
      -- For example, to disable Copilot for Markdown files:
      -- vim.g.copilot_filetypes = { markdown = false }
    end
  }

  -- Treesitter configuration
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },
        indent = { enable = true },
        ensure_installed = { "javascript", "css", "scss", "html", "rust", "zig", "glimmer" },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
      }
    end,
  }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').tsserver.setup {}
      -- Repeat the pattern for other servers
      require('lspconfig').cssls.setup {}
      require('lspconfig').html.setup {}
      require('lspconfig').rust_analyzer.setup {}
      require('lspconfig').solargraph.setup {}
      require('lspconfig').lua_ls.setup {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      }
    end
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use {
    'vifm/vifm.vim'
  }
end)

require("ibl").setup();

require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.prettier.with({
      -- Specify any Prettier options here
      -- You can specify the filetypes it should apply to, among other settings
      filetypes = { "javascript", "typescript", "css", "html", "hbs", "handlebars", "json", "ruby", "scss", "yaml", "markdown"},
    }),
  },
})

require 'cmp'.setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}

require 'colorizer'.setup({
  'css',
  'scss',
  'javascript',                -- Specify the file types you want to enable colorizer for
  html = { mode = 'background' },
  css = { rgb_fn = true, }     -- Enable CSS rgb() and rgba() functions
}, {
  mode = 'background',         -- Default mode for all file types not explicitly listed
})


vim.g['vifm_replace_netrw'] = 1


vim.g.mapleader = ' '
vim.g.user_emmet_leader_key = ','

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Modify the behavior of arrow keys in command-line mode.
vim.api.nvim_set_keymap('c', '<up>', 'wildmenumode() ? "\\<left>" : "\\<up>"', { expr = true })
vim.api.nvim_set_keymap('c', '<down>', 'wildmenumode() ? "\\<right>" : "\\<down>"', { expr = true })
-- vim.api.nvim_set_keymap('c', '<left>', 'wildmenumode() ? "\\<up>" : "\\<left>"', { expr = true })
-- vim.api.nvim_set_keymap('c', '<right>', 'wildmenumode() ? " \\<bs>\\<C-Z>" : "\\<right>"', { expr = true })

-- Setup mapping to call :LazyGit
vim.api.nvim_set_keymap('n', '<leader>lg', ':LazyGit<CR>', { noremap = true, silent = true })

-- Setup mapping to call :Vifm
vim.api.nvim_set_keymap('n', '<leader>vm', ':Vifm<CR>', { noremap = true, silent = true })

-- fzf file fuzzy search that respects .gitignore
-- If in git directory, show only files that are committed, staged, or unstaged
-- else use regular :Files
vim.api.nvim_set_keymap('n', '<C-p>',
  [[len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached']],
  { expr = true, noremap = true })

-- Setup mapping to call :LazyGit
vim.api.nvim_set_keymap('n', '<leader>lg', ':LazyGit<CR>', { noremap = true, silent = true })

-- Setup mapping to call :Vifm
vim.api.nvim_set_keymap('n', '<leader>vm', ':Vifm<CR>', { noremap = true, silent = true })

-- fzf file fuzzy search that respects .gitignore
-- If in git directory, show only files that are committed, staged, or unstaged
-- else use regular :Files
vim.api.nvim_set_keymap('n', '<C-p>',
  [[len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached']],
  { expr = true, noremap = true })

vim.api.nvim_exec([[ autocmd BufEnter *.hbs :set ft=html ]], false)
vim.api.nvim_exec([[ autocmd BufEnter *.handlebars :set ft=html ]], false)

-- easy navigation between splits
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', { noremap = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.textwidth = 80
    vim.opt_local.colorcolumn = "81"
    vim.cmd("highlight ColorColumn ctermbg=Yellow guibg=#3B1F1C")
  end,
})

vim.cmd [[colorscheme moonfly]]
vim.cmd [[
command! Prettier lua vim.lsp.buf.format({ async = true })
]]

vim.opt.background = 'dark'
