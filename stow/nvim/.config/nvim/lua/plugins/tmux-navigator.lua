-- Seamless pane navigation with Ctrl-h/j/k/l:
--   inside Herdr  → herdr panes + nvim splits (HERDR_PANE_ID)
--   inside tmux   → tmux panes + nvim splits (vim-tmux-navigator)
--   bare nvim     → nvim splits only
-- Keep in sync with stow/tmux/tmux.conf and stow/herdr/config.toml.
-- Herdr side also needs: make herdr-plugins  (vim-herdr-navigation)

local function navigate(wincmd, direction)
  local prev = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd)
  if vim.api.nvim_get_current_win() ~= prev then
    return
  end

  local herdr_pane = vim.env.HERDR_PANE_ID
  if herdr_pane and herdr_pane ~= "" then
    local herdr = vim.env.HERDR_BIN_PATH
    if herdr == nil or herdr == "" then
      herdr = "herdr"
    end
    vim.fn.system({ herdr, "pane", "focus", "--direction", direction, "--pane", herdr_pane })
    return
  end

  if vim.env.TMUX and vim.env.TMUX ~= "" then
    local cmds = {
      left = "TmuxNavigateLeft",
      down = "TmuxNavigateDown",
      up = "TmuxNavigateUp",
      right = "TmuxNavigateRight",
    }
    pcall(vim.cmd, cmds[direction])
  end
end

return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    init = function()
      -- We own <C-h/j/k/l> so the same keys work under Herdr and tmux.
      vim.g.tmux_navigator_no_mappings = 1
    end,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      {
        "<C-h>",
        function()
          navigate("h", "left")
        end,
        mode = { "n", "t" },
        desc = "Navigate left (herdr/tmux/nvim)",
      },
      {
        "<C-j>",
        function()
          navigate("j", "down")
        end,
        mode = { "n", "t" },
        desc = "Navigate down (herdr/tmux/nvim)",
      },
      {
        "<C-k>",
        function()
          navigate("k", "up")
        end,
        mode = { "n", "t" },
        desc = "Navigate up (herdr/tmux/nvim)",
      },
      {
        "<C-l>",
        function()
          navigate("l", "right")
        end,
        mode = { "n", "t" },
        desc = "Navigate right (herdr/tmux/nvim)",
      },
    },
  },
}
