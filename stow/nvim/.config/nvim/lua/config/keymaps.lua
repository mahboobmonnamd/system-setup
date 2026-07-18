-- Keymaps on top of LazyVim defaults
-- (LazyVim's own: <Space> = leader/command menu, <Space><Space> find files,
--  <Space>e file tree, <Space>gg lazygit, Shift-h/l switch buffers)

-- jk in insert mode = Escape (fingers stay on home row)
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- <Space>w = save
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
