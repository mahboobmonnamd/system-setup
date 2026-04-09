-- Options are automatically loaded before lazy.nvim startup
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Editor feel
opt.timeoutlen = 300       -- faster which-key popup
opt.scrolloff = 8          -- keep 8 lines visible above/below cursor
opt.sidescrolloff = 8      -- keep 8 columns visible left/right of cursor
opt.wrap = false           -- no line wrapping
opt.colorcolumn = "100"    -- visual ruler at 100 chars

-- Splits open in a natural direction
opt.splitright = true
opt.splitbelow = true

-- Completion popup
opt.pumheight = 10         -- max 10 items visible at once

-- Persistence
opt.undofile = true        -- persist undo history across sessions
opt.swapfile = false       -- no swap files (undo + git is enough)

-- Clipboard
opt.clipboard = "unnamedplus" -- use system clipboard for yank/paste
