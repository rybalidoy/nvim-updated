return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
          search_down = { view = "cmdline_popup", icon = " ", lang = "regex" },
          search_up = { view = "cmdline_popup", icon = " ", lang = "regex" },
        },
      },
      views = {
        cmdline_popup = {
          position = { row = "40%", col = "50%" },
          size = { width = 60, height = "auto" },
        },
      },
      presets = {
        bottom_search = false,
      },
    },
  },
}
