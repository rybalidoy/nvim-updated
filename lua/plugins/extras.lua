return {
  -- Harpoon
  {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      vim.keymap.set("n", "<leader>ah", function() harpoon:list():add() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon quick menu" })

      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
    end,
  },

  -- Undotree
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },

  -- ToggleTerm
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      size = 20,
      direction = 'float',
    },
    keys = {
      { '<leader>fs', '<cmd>ToggleTerm direction=float size=100<cr>', desc = 'Toggle Fullscreen Shell' },
    },
  },

  -- LazyGit
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" }
    }
  },

  -- Autopairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- Colorizer
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = true,
          AARRGGBB = true,
          rgb_fn = true,
          hsl_fn = true,
          css = true,
          css_fn = true,
          mode = "background",
          tailwind = true,
        },
      })
    end,
  },

  -- Grug-far
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        "<leader>pr",
        function()
          local current_file = vim.api.nvim_buf_get_name(0)
          if current_file ~= "" and vim.fn.filereadable(current_file) == 1 then
            require("grug-far").open({ prefills = { paths = current_file } })
          else
            require("grug-far").open()
          end
        end,
        desc = "Search & Replace in Current File",
      },
    },
    config = function()
      require("grug-far").setup({
        engine = { rg = { args = { "--vimgrep" } } },
      })
    end,
  },
}
