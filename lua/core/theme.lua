local theme_state_file = vim.fn.stdpath("data") .. "/theme_settings_v2.txt"

local M = {
  theme = "catppuccin",
  variant = "mocha",
  mode = "dark",
  transparent = false,
}

-- Registry of available variants for each theme
M.available_variants = {
  catppuccin = { "latte", "frappe", "macchiato", "mocha" },
  tokyonight = { "night", "storm", "day", "moon" },
  ["rose-pine"] = { "main", "moon", "dawn" },
  ["gruvbox-material"] = { "hard", "medium", "soft" },
  everforest = { "hard", "medium", "soft" },
}

-- Apply the current state to Neovim
function M.Apply()
  -- 1. Set background mode
  vim.o.background = M.mode
  
  -- 2. Configure variants BEFORE loading colorscheme
  if M.theme == "catppuccin" then
    vim.g.catppuccin_flavour = M.variant
  elseif M.theme == "tokyonight" then
    -- tokyonight uses variants as actual colorscheme names often, 
    -- but we can use the config if needed. 
    -- Actually, tokyonight-[variant] is a common pattern, 
    -- but lsp-config likes the base.
  elseif M.theme == "gruvbox-material" then
    vim.g.gruvbox_material_background = M.variant
  elseif M.theme == "everforest" then
    vim.g.everforest_background = M.variant
  end

  -- 3. Load colorscheme
  local colorscheme_name = M.theme
  
  -- Special handling for themes where variants are different colorscheme names
  if M.theme == "catppuccin" then
    colorscheme_name = "catppuccin-" .. M.variant
  elseif M.theme == "tokyonight" then
    colorscheme_name = "tokyonight-" .. M.variant
  elseif M.theme == "rose-pine" and M.variant ~= "main" then
    colorscheme_name = "rose-pine-" .. M.variant
  end

  local ok, _ = pcall(vim.cmd.colorscheme, colorscheme_name)
  if not ok then
    pcall(vim.cmd.colorscheme, "catppuccin-mocha")
  end

  -- 4. Handle Transparency
  if M.transparent then
    local hl_groups = {
      "Normal", "NormalFloat", "NormalNC", "NvimTreeNormal", "NvimTreeNormalNC",
      "MsgArea", "Pmenu", "TelescopeNormal", "TelescopeBorder"
    }
    for _, group in ipairs(hl_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
  end

  -- 5. Persist state
  local f = io.open(theme_state_file, "w")
  if f then
    f:write(string.format("%s:%s:%s:%s", M.theme, M.variant, M.mode, tostring(M.transparent)))
    f:close()
  end
end

-- Global function required by user's old keymaps
_G.ColorMyPencils = function(theme)
  M.theme = theme
  -- Reset variant to first available or default
  M.variant = M.available_variants[theme] and M.available_variants[theme][1] or ""
  M.Apply()
end

-- Set a specific variant
function M.SetVariant(variant)
  M.variant = variant
  M.Apply()
end

-- Toggle between dark and light
function M.ToggleMode()
  M.mode = (M.mode == "dark") and "light" or "dark"
  -- Reset if specific variants are light-only (like catppuccin-latte)
  if M.mode == "light" and M.theme == "catppuccin" then M.variant = "latte" end
  if M.mode == "dark" and M.theme == "catppuccin" and M.variant == "latte" then M.variant = "mocha" end
  M.Apply()
end

-- Toggle transparency
function M.ToggleTransparency()
  M.transparent = not M.transparent
  M.Apply()
end

function M.RestoreTheme()
  local f = io.open(theme_state_file, "r")
  if f then
    local data = f:read("*l")
    f:close()
    if data then
      local parts = vim.split(data, ":")
      M.theme = parts[1] or "catppuccin"
      M.variant = parts[2] or "mocha"
      M.mode = parts[3] or "dark"
      M.transparent = (parts[4] == "true")
      M.Apply()
      return
    end
  end
  M.Apply()
end

return M
