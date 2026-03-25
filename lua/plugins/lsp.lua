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
			local util = require("lspconfig.util")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")

			mason.setup({
				ui = {
					icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
				},
			})

			-- Detect Biome
			local has_biome = util.root_pattern("biome.json", "biome.jsonc")(vim.fn.getcwd())

			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"html",
					"cssls",
					"tailwindcss",
					"bashls",
					"intelephense",
					"volar",
					"biome",
					"eslint",
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local configs = require("lspconfig.configs")

			local servers = {
				"lua_ls",
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"bashls",
				"intelephense",
				"volar",
				"biome",
				"eslint",
			}

			for _, server in ipairs(servers) do
				-- 1. Skip ESLint if Biome is present
				if server == "eslint" and has_biome then
					goto continue
				end

				-- 2. Skip Biome if no config is found (optional, keeps it clean)
				if server == "biome" and not has_biome then
					goto continue
				end

				if not configs[server] then
					goto continue
				end

				local config = { capabilities = capabilities }

				if server == "lua_ls" then
					config.settings = { Lua = { diagnostics = { globals = { "vim" } } } }
				end

				if server == "intelephense" then
					config.filetypes = { "php", "blade" }
					config.settings = { intelephense = { licenceKey = nil } }
				end

				-- Disable formatting for ts_ls if Biome is handling it
				if server == "ts_ls" then
					config.on_attach = function(client)
						if has_biome then
							client.server_capabilities.documentFormattingProvider = false
						end
					end
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
					local local_ts = vim.fn.getcwd() .. "/node_modules/typescript/lib"
					local tsdk = (vim.fn.isdirectory(local_ts) == 1) and local_ts or nil
					config.init_options = {
						typescript = tsdk and { tsdk = tsdk } or nil,
						vue = { hybridMode = false },
					}
				end

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
