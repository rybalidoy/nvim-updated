-- Fix for Neovim 0.11+ (ft_to_lang was removed)
-- This MUST be at the top to fix plugins like Telescope
if vim.treesitter.language and not vim.treesitter.language.ft_to_lang then
  vim.treesitter.language.ft_to_lang = function(ft)
    return vim.treesitter.language.get_lang(ft) or ft
  end
end

require("core.options")
require("core.keymaps")
require("core.lazy")

-- Theme persistence and restoration
local Theme = require("core.theme")
Theme.RestoreTheme()
