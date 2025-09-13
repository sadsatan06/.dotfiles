-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- General options
vim.opt.termguicolors = true
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("hi NormalNC guibg=NONE ctermbg=NONE")
vim.cmd("hi NormalFloat guibg=NONE")

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Plugins via lazy.nvim
require("lazy").setup({

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        highlight = { enable = true },
        indent = { enable = true },
      }
    end
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").clangd.setup {}
    end
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  },

  -- Snippets
  { "L3MON4D3/LuaSnip" },

  -- File explorer
  {
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup {
        disable_netrw = true,
        hijack_netrw = true,
        open_on_setup = false,
        ignore_ft_on_setup = {},
        auto_close = true,
        hijack_cursor = true,
        update_cwd = true,
        view = { width = 30, side = "left", auto_resize = true },
      }

      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end
  },

})

-- F5 keymap to compile and run C++ code
vim.keymap.set("n", "<F5>", function()
  local file = vim.fn.expand("%")
  local out = vim.fn.expand("%:r")
  vim.cmd("terminal g++ " .. file .. " -o " .. out .. " && ./" .. out)
end, { noremap = true })

