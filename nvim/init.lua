-- general settings -----------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 1
vim.opt.colorcolumn = "80"

vim.cmd("highlight Normal ctermbg=NONE guibg=NON")

-- paq package manager --------------------------------------------------------
require "paq" {
    "savq/paq-nvim",    -- Let Paq manage itself

    "rktjmp/lush.nvim", -- required for bluloco.nvim
    "uloco/bluloco.nvim",

    "nvim-lualine/lualine.nvim",

    "nvim-treesitter/nvim-treesitter",

    "nvim-lua/plenary.nvim", -- required for telescope
    "nvim-telescope/telescope.nvim",

    "stevearc/oil.nvim", -- dired for non saints

    "voldikss/vim-floaterm",

    "lewis6991/gitsigns.nvim",
    "terrortylor/nvim-comment",

    "neovim/nvim-lspconfig",
    "folke/lazydev.nvim", -- makes lua_ls aware of vim names

    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
}

--Theme------------------------------------------------------------------------
-- Bluloco colorscheme
require("bluloco").setup({
    style       = "light", -- "auto" | "dark" | "light"
    transparent = false,
    italics     = true,
    terminal    = vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
    guicursor   = true,
})
vim.cmd('colorscheme bluloco')


--Modeline---------------------------------------------------------------------
-- TODO: customize lualine a bit
require("lualine").setup({
    options = {
        theme = 'auto'
    }
})

--TreeSitter--------------------------------------------------------------------
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "ledger", "rust", "markdown", "lua", "sql", "markdown_inline", "go", "latex", "toml" },
    sync_install = false, -- disable synchroise download of parsers
    auto_install = false, -- don't do anything without my permission
    ignore_install = {},
    modules = {},

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}

--Telescope--------------------------------------------------------------------
require("telescope").setup {}

--Oil--------------------------------------------------------------------------
require("oil").setup {}

--LspConfig--------------------------------------------------------------------
local lspconfig = require("lspconfig")
require("lazydev").setup {}
lspconfig.gopls.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.lua_ls.setup {}

--GitSigns---------------------------------------------------------------------
require("gitsigns").setup {}

--cmp--------------------------------------------------------------------------
local cmp = require("cmp")

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-l>'] = cmp.mapping.confirm({ select = true }),
        ['<C-e>'] = cmp.mapping.abort(),
    }),
    sources = cmp.config.sources(
        {{ name = 'nvim_lsp' }},
        {{ name = 'path'}},
        {{ name = 'buffer' },
    })
})

--Comments---------------------------------------------------------------------
require("nvim_comment").setup()

--Keybinds---------------------------------------------------------------------
local map = function(mode, keys, n)
    vim.keymap.set(mode, keys, n)
end
local telescope = require("telescope.builtin")

--Buffer
map("n", "<leader>bn", ":enew<CR>")       -- new Buffer
map("n", "<leader>bb", telescope.buffers) -- switch buffer
map("n", "<leader>bk", ":bd<CR>")         -- delete buffer
map("n", "<leader>bK", ":%bd<CR>")        -- delete all buffer

map("n", "<M-j>", ":cnext<CR>")
map("n", "<M-k>", ":cprev<CR>")
map("n", "<M-c>", ":cclose<CR>")
map("n", "<M-o>", ":copen<CR>")

-- Terminal Shit
map("t", "<ESC>", "<C-\\><C-n>")
map("n", "<leader>tt", ":FloatermToggle<CR>")

--Files
map("n", "<leader>.", telescope.find_files)
map("n", "<leader>pf", telescope.git_files)

--Grep
map("n", "<leader>lg", telescope.live_grep)

--Comment
map("n", "<leader>cc", ":CommentToggle<CR>")
map("v", "<leader>cc", ":CommentToggle<CR>")

--LspNavigation
map("n", "grr", vim.lsp.buf.references)
map("n", "grn", vim.lsp.buf.rename)
map("n", "gra", vim.lsp.buf.code_action)
map("n", "grf", vim.lsp.buf.format)
map("n", "K", vim.lsp.buf.hover)

-- Move lines Up and Down
map("v", "K", ":m '<-2<CR>gv=gv") -- move line up(v)
map("v", "J", ":m '>+1<CR>gv=gv") -- move line down(v)
