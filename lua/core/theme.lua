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
  -- 1. Auto-detect mode based on theme/variant
  if (M.theme == "catppuccin" and M.variant == "latte") or
     (M.theme == "tokyonight" and M.variant == "day") or
     (M.theme == "rose-pine" and M.variant == "dawn") then
    M.mode = "light"
  elseif M.theme == "everforest" or M.theme == "gruvbox-material" then
    -- These depend on what the user sets, but usually we can default to dark
    -- unless they specifically toggle light mode.
  else
    M.mode = "dark"
  end

  -- 2. Set background mode
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

  -- 5. Cursor Visibility Enhancement
  M.FixCursor()

  -- 6. Persist state
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
  -- Reset if specific variants are light-only
  if M.mode == "light" then
    if M.theme == "catppuccin" then M.variant = "latte" end
    if M.theme == "rose-pine" then M.variant = "dawn" end
    if M.theme == "tokyonight" then M.variant = "day" end
  else
    if M.theme == "catppuccin" and M.variant == "latte" then M.variant = "mocha" end
    if M.theme == "rose-pine" and M.variant == "dawn" then M.variant = "main" end
    if M.theme == "tokyonight" and M.variant == "day" then M.variant = "moon" end
  end
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

function M.FixCursor()
  -- Using bright, colorful backgrounds to ensure the cursor is visible 
  -- even if the terminal ignores the foreground (text) color.
  if vim.o.background == "light" then
    -- Light mode: High-contrast Orange background, Black text
    vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#FF9E3B", bold = true })
    vim.api.nvim_set_hl(0, "TermCursor", { fg = "#000000", bg = "#FF9E3B" })
  else
    -- Dark mode: High-contrast Cyan background, Black text
    vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#00FFFF", bold = true })
    vim.api.nvim_set_hl(0, "TermCursor", { fg = "#000000", bg = "#00FFFF" })
  end
  
  -- Use a block cursor for all modes to maximize visibility of the color
  vim.opt.guicursor = "n-v-c-i:block-Cursor,a:blinkwait700-blinkoff400-blinkon250-Cursor"
end

-- Ensure highlights are re-applied if the colorscheme is changed manually
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = function()
    -- Standard delay to ensure overrides stick
    vim.defer_fn(function()
      M.FixCursor()
    end, 300)
  end,
})

return M
