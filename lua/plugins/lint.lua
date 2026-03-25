return {
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")

			-- Dynamic detection of Biome
			-- Checks for biome.json or biome.jsonc in the current or parent directories
			local has_biome = #vim.fs.find(
				{ "biome.json", "biome.jsonc" },
				{ upward = true, stop = vim.uv.os_homedir() }
			) > 0

			-- Set linters based on Biome presence
			if has_biome then
				-- If Biome is present, we rely on the Biome LSP for linting
				lint.linters_by_ft = {
					lua = { "luacheck" },
					-- Add other non-JS/TS linters here if needed
				}
			else
				-- Fallback to eslint_d if Biome is NOT found
				lint.linters_by_ft = {
					javascript = { "eslint_d" },
					typescript = { "eslint_d" },
					javascriptreact = { "eslint_d" },
					typescriptreact = { "eslint_d" },
					lua = { "luacheck" },
				}
			end

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Only attempt to lint if a linter is actually defined for the filetype
					-- This prevents errors in projects where we purposefully cleared the list
					lint.try_lint()
				end,
			})
		end,
	},
}
