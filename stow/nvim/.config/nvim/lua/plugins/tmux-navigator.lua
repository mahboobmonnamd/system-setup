-- Seamless tmux ↔ nvim pane navigation with WASD (not hjkl).
-- Must match stow/tmux/.config/tmux/tmux.conf @vim_navigator_mapping_*.
-- Ctrl-a left · Ctrl-w up · Ctrl-s down · Ctrl-d right

return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-a>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left (tmux/nvim)" },
      { "<C-w>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up (tmux/nvim)", remap = true },
      { "<C-s>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down (tmux/nvim)" },
      { "<C-d>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right (tmux/nvim)" },
    },
    init = function()
      -- Disable plugin defaults (Ctrl-h/j/k/l) so only WASD maps apply.
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
}
