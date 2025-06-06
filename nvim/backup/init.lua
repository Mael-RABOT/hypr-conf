-- ========================================
-- NEOVIM CONFIGURATION
-- ========================================
-- ASCII Art Style Neovim Configuration
-- Matching waybar and terminal theme

-- ========================================
-- BASIC SETTINGS
-- ========================================

-- Line numbers (requested feature)
vim.opt.number = true
vim.opt.relativenumber = true

-- Basic UI settings
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Window behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Theme and colors
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- ========================================
-- PLUGIN MANAGER SETUP (lazy.nvim)
-- ========================================

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

-- ========================================
-- PLUGINS CONFIGURATION
-- ========================================

require("lazy").setup({
  -- File Tree (requested feature)
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- File icons
    },
    config = function()
      -- Disable netrw (vim's default file explorer)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        -- ASCII art style configuration
        view = {
          width = 30,
          side = "left",
          number = false,
          relativenumber = false,
        },
        renderer = {
          -- Bracket-style icons (matching waybar theme)
          add_trailing = true,
          group_empty = true,
          highlight_git = true,
          highlight_opened_files = "name",
          indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "├",
              none = " ",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = "📄",
              symlink = "🔗",
              bookmark = "🔖",
              folder = {
                arrow_closed = "▶",
                arrow_open = "▼",
                default = "📁",
                open = "📂",
                empty = "📁",
                empty_open = "📂",
                symlink = "🔗",
                symlink_open = "🔗",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "⌘",
                renamed = "➜",
                untracked = "★",
                deleted = "⊖",
                ignored = "◌",
              },
            },
          },
        },
        filters = {
          dotfiles = false,
          custom = { ".git", "node_modules", ".cache" },
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 400,
        },
        -- Waybar-style window behavior
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = false,
          },
        },
      })
    end,
  },

  -- Color scheme (dark theme matching your setup)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- Dark theme to match terminal
        transparent = true, -- Match terminal transparency
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
        },
      })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- Status line (matching waybar aesthetic)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return "[ " .. str .. " ]"
              end,
            },
          },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = {
            {
              "location",
              fmt = function(str)
                return "[ " .. str .. " ]"
              end,
            },
          },
        },
      })
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "bash", "python", "javascript", "html", "css", "json"
        },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
})

-- ========================================
-- KEY MAPPINGS
-- ========================================

-- Set leader key
vim.g.mapleader = " "

-- File tree toggle (matching waybar interaction style)
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "[ Toggle File Tree ]" })
vim.keymap.set("n", "<leader>f", ":NvimTreeFocus<CR>", { desc = "[ Focus File Tree ]" })

-- Basic navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "[ Move Left ]" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "[ Move Down ]" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "[ Move Up ]" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "[ Move Right ]" })

-- Tab management (matching kitty/terminal shortcuts)
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "[ New Tab ]" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "[ Close Tab ]" })
vim.keymap.set("n", "<leader>tr", ":TabRename ", { desc = "[ Rename Tab ]" })

-- Buffer management
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "[ Delete Buffer ]" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "[ Next Buffer ]" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "[ Previous Buffer ]" })

-- Search and replace
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "[ Clear Search Highlights ]" })

-- ========================================
-- AUTO COMMANDS
-- ========================================

-- Auto-open file tree when starting nvim with a directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      vim.cmd("NvimTreeOpen")
    end
  end,
})

-- Auto-close nvim if file tree is the last window
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(tree_wins, w)
      end
      if vim.api.nvim_win_get_config(w).relative ~= "" then
        table.insert(floating_wins, w)
      end
    end
    if 1 == #wins - #floating_wins - #tree_wins then
      for _, w in ipairs(tree_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})

-- ========================================
-- WELCOME MESSAGE
-- ========================================
print("[ NEOVIM ] | [ ASCII Art Theme ] | [ Ready ]")