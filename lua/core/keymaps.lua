vim.diagnostic.config({
  virtual_text = true,
  float = { border = 'rounded' },
})

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Disable arrow keys
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("n", "<leader>.", ">>", { noremap = true, silent = true, desc = "Indent line" })
vim.keymap.set("n", "<leader>,", "<<", { noremap = true, silent = true, desc = "Unindent line" })

vim.keymap.set("v", "<leader>.", ">gv", { noremap = true, silent = true, desc = "Indent selection" })
vim.keymap.set("v", "<leader>,", "<gv", { noremap = true, silent = true, desc = "Unindent selection" })

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- LSP Mappings (conditionally applied in LspAttach)
vim.api.nvim_create_autocmd(
  "LspAttach",
  { 
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      local opts = { buffer = ev.buf } 
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, opts)

      vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.open_float({ border = "rounded" })
      end, opts)
    end,
  }
)

-- Toggle file explorer (NvimTree)
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Theme selection (using ColorMyPencils)
vim.keymap.set("n", "<leader>ct", function()
  local theme_mod = require("core.theme")
  local themes = {
    "catppuccin",
    "rose-pine",
    "tokyonight",
    "gruvbox-material",
    "everforest",
  }

  vim.ui.select(themes, { prompt = "Select a colorscheme:" }, function(choice)
    if choice then
      ColorMyPencils(choice)
      -- If there are variants, ask for them too
      local available = theme_mod.available_variants[choice]
      if available then
        vim.defer_fn(function()
          vim.ui.select(available, { prompt = "Select a variant (flavor):" }, function(variant)
            if variant then
              theme_mod.SetVariant(variant)
            end
          end)
        end, 100)
      end
    end
  end)
end, { desc = "Change Theme and Variant" })

-- Variant selection only
vim.keymap.set("n", "<leader>cv", function()
  local theme_mod = require("core.theme")
  local available = theme_mod.available_variants[theme_mod.theme]
  if not available then
    print("No variants available for " .. theme_mod.theme)
    return
  end

  vim.ui.select(available, { prompt = "Select a variant (flavor):" }, function(variant)
    if variant then
      theme_mod.SetVariant(variant)
    end
  end)
end, { desc = "Change Theme Variant" })

-- Theme Modes
vim.keymap.set("n", "<leader>tm", function() 
  require("core.theme").ToggleMode()
end, { desc = "Toggle Dark/Light Mode" })

-- Transparency
vim.keymap.set("n", "<leader>tt", function() 
  require("core.theme").ToggleTransparency()
end, { desc = "Toggle Transparency" })

-- Utility: Remove carriage returns (^M) from the whole file
vim.keymap.set('n', '<leader>rm', ':%s/\\r//g<CR>', { desc = 'Remove Windows ^M characters' })

-- Yank Highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})
