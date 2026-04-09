return {
  -- VSCode Light+: closest nvim equivalent to VSCode's default light theme
  {
    "Mofiqul/vscode.nvim",
    priority = 1000, -- load before all other plugins
    opts = {
      style = "light",
      transparent = false,
      italic_comments = true,
    },
  },

  -- Tell LazyVim to use vscode as the active colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },

  -- Disable tokyonight (LazyVim default) so it doesn't compete
  { "folke/tokyonight.nvim", enabled = false },
}
