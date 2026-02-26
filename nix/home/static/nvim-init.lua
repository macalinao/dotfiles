-- Settings from vim config
vim.opt.number = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

-- theme
vim.cmd.colorscheme "catppuccin"

-- Leader key
vim.g.mapleader = " "

-- Telescope (file picker)
local telescope = require("telescope")
telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/" },
  },
})
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Treesitter (parsers installed via nix, just enable highlighting)
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Lualine (status line)
require("lualine").setup()

-- LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "nil_ls", "rust_analyzer", "ts_ls", "gopls", "pyright", "svelte" }
for _, server in ipairs(servers) do
  vim.lsp.config(server, { capabilities = capabilities })
end
vim.lsp.enable(servers)

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)

-- Inline diagnostics
require("tiny-inline-diagnostic").setup({ preset = "modern" })
vim.diagnostic.config({ virtual_text = false })

-- Autocomplete
local cmp = require("cmp")
cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
})

-- Gitsigns
require("gitsigns").setup()

-- Surround
require("nvim-surround").setup()

-- Comment
require("Comment").setup()

-- Autopairs
require("nvim-autopairs").setup()

-- Indent guides
require("ibl").setup()

-- Split navigation with Ctrl+hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Which-key (keybinding hints)
require("which-key").setup()

-- Neo-tree (file explorer)
require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
})
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>")

-- Conform (format on save)
require("conform").setup({
  formatters_by_ft = {
    nix = { "nixfmt" },
    lua = { "stylua" },
    javascript = { "biome" },
    typescript = { "biome" },
    typescriptreact = { "biome" },
    json = { "biome" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    css = { "biome" },
    html = { "biome" },
    svelte = { "biome" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    rust = { "rustfmt" },
    go = { "gofmt" },
    python = { "black" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

