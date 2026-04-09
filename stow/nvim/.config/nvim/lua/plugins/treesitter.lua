return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- Web / TypeScript
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "json",
        "jsonc",
        -- Python
        "python",
        -- Config / tooling
        "toml",
        "yaml",
        "dockerfile",
        "graphql",
        -- Shell
        "bash",
        -- Neovim
        "lua",
        "vim",
        "vimdoc",
        -- Docs
        "markdown",
        "markdown_inline",
      })
    end,
  },

  -- Show current code context (function/class name) in status line
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 3,       -- max lines the context window can take up
      trim_scope = "outer",
    },
  },
}
