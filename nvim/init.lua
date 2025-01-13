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

--vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 1
vim.opt.colorcolumn = "80"

vim.cmd("highlight Normal ctermbg=NONE guibg=NON")

-- paq package manager --------------------------------------------------------
require "paq" {
    "savq/paq-nvim",    -- Let Paq manage itself

    "rose-pine/neovim",

    "nvim-lualine/lualine.nvim",

    "SCJangra/table-nvim",

    "nvim-treesitter/nvim-treesitter",

    -- Git stuff
    "NeogitOrg/neogit",
    "sindrets/diffview.nvim",

    "nvim-lua/plenary.nvim", -- required for telescope, neogit
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
-- RosePine colorscheme
require("rose-pine").setup({
    variant = "dawn", -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
    },

    styles = {
        bold = true,
        italic = true,
        transparency = false,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
    },

    palette = {
        -- Override the builtin palette per variant
        -- moon = {
        --     base = '#18191a',
        --     overlay = '#363738',
        -- },
    },

    highlight_groups = {
        -- Comment = { fg = "foam" },
        -- VertSplit = { fg = "muted", bg = "muted" },
    },

    before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
    end,
})

vim.cmd("colorscheme rose-pine")

--Modeline---------------------------------------------------------------------
-- TODO: customize lualine a bit
require("lualine").setup({
    options = {
        theme = 'auto'
    }
})

--Markdown-Table----------------------------------------------------------------
require("table-nvim").setup {}

--TreeSitter--------------------------------------------------------------------
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "yaml", "ledger", "rust", "markdown", "lua", "sql", "markdown_inline", "go", "latex", "toml" },
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

--NeoGit-----------------------------------------------------------------------
require("neogit").setup({})
local neogit = require("neogit")

--Oil--------------------------------------------------------------------------
require("oil").setup {}

--LspConfig--------------------------------------------------------------------
local lspconfig = require("lspconfig")
require("lazydev").setup {}
lspconfig.gopls.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.lua_ls.setup {}
lspconfig.clangd.setup {}

--GitSigns---------------------------------------------------------------------
require("gitsigns").setup {}

--cmp--------------------------------------------------------------------------
local cmp = require("cmp")

cmp.setup({
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
        { { name = 'nvim_lsp' } },
        { { name = 'path' } },
        { { name = 'buffer' },
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

--Comment
map("n", "<leader>cc", ":CommentToggle<CR>")
map("v", "<leader>cc", ":CommentToggle<CR>")

-- Git
--map("n", "<leader>gs", neogit.open({"commit"}))

--LspNavigation
map("n", "lrr", vim.lsp.buf.references)
map("n", "lrn", vim.lsp.buf.rename)
map("n", "lra", vim.lsp.buf.code_action)
map("n", "lrf", vim.lsp.buf.format)
map("n", "K", vim.lsp.buf.hover)

-- Move lines Up and Down
map("v", "K", ":m '<-2<CR>gv=gv") -- move line up(v)
map("v", "J", ":m '>+1<CR>gv=gv") -- move line down(v)
