return {
  -- Mason: auto-installs language servers
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Language servers
        "typescript-language-server",
        "pyright",
        "json-lsp",
        "lua-language-server",
        -- Formatters (used by conform in formatting.lua)
        "prettier",
        "prettierd",
        "black",
        "isort",
        "stylua",
        "shfmt",
        -- Linters (used by nvim-lint in formatting.lua)
        "eslint_d",
        "flake8",
        "mypy",
      },
    },
  },

  -- nvim-lspconfig: configure each language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TypeScript / JavaScript
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },

        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic", -- "off" | "basic" | "strict"
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },

        -- JSON with schema support
        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
            },
          },
        },

        -- Lua (for editing neovim config itself)
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              hint = { enable = true },
            },
          },
        },
      },
    },
  },

  -- Auto-close and rename JSX/HTML tags
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
