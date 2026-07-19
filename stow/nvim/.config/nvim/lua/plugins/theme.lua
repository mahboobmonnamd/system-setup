-- Catppuccin Latte (light) — matches Ghostty/tmux/starship/lazygit
-- lazy=false so setup runs before LazyVim applies the colorscheme; otherwise
-- mocha loads first and Latte opts never take effect (unreadable on a light terminal).
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "latte",
      -- Stay on Latte even if background is toggled (e.g. <leader>ub).
      background = { light = "latte", dark = "latte" },
      -- Default Latte greys (comments, LineNr, etc.) are too washed out on #eff1f5.
      color_overrides = {
        latte = {
          overlay2 = "#5c5f77", -- comments (was #7c7f93)
          overlay1 = "#6c6f85",
          overlay0 = "#7c7f93",
          surface2 = "#8c8fa1",
          surface1 = "#9ca0b0", -- line numbers (was #bcc0cc)
          surface0 = "#acb0be",
        },
      },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-latte" } },
}
