return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- In Neovim 0.11+, nvim-treesitter 1.0.0 uses a different structure.
    -- We can often just use the opts table.
    opts = {
      ensure_installed = { 
        "lua", "vim", "vimdoc", "javascript", "typescript", 
        "html", "css", "json", "bash", "php", "vue", "blade", "rust" 
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      -- Try-catch for the config module change in 1.0.0
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        configs.setup(opts)
      end
    end,
  },
}
