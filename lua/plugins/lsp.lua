return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "Saghen/blink.cmp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup({
        ui = {
          icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
        },
      })

      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls", "ts_ls", "html", "cssls", "tailwindcss", "bashls",
          "intelephense", "volar",
        },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local configs = require("lspconfig.configs")
      local servers = {
        "lua_ls", "ts_ls", "html", "cssls", "tailwindcss", "bashls",
        "intelephense", "volar"
      }

      for _, server in ipairs(servers) do
        -- Check existence without triggering deprecation
        if not configs[server] then goto continue end

        local config = { capabilities = capabilities }
        
        if server == "lua_ls" then
          config.settings = { Lua = { diagnostics = { globals = { "vim" } } } }
        end
        
        if server == "intelephense" then
          config.filetypes = { "php", "blade" }
          config.settings = { intelephense = { licenceKey = nil } }
        end
        
        if server == "ts_ls" or server == "tsserver" then
          config.settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          }
        end
        
        if server == "volar" then
          -- Get TSDK for Volar (Vue/Nuxt)
          local local_ts = vim.fn.getcwd() .. '/node_modules/typescript/lib'
          local tsdk = (vim.fn.isdirectory(local_ts) == 1) and local_ts or nil
          
          config.init_options = {
            typescript = tsdk and { tsdk = tsdk } or nil,
            vue = { hybridMode = false },
          }
        end

        -- Use modern Neovim 0.11+ API if available
        if vim.lsp.config then
          vim.lsp.config(server, config)
          vim.lsp.enable(server)
        else
          lspconfig[server].setup(config)
        end

        ::continue::
      end
    end,
  },
}
