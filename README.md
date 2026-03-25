# 🌙 Modern Neovim Configuration

A high-performance, modular Neovim configuration built for modern development. Featuring a sophisticated theme system, robust LSP integration, and a sleek UI.

## ✨ Features

- 📦 **Modular Configuration**: Clean and organized structure using `lazy.nvim`.
- 🚀 **LSP Support**: Pre-configured for Lua, TypeScript, Vue/Nuxt, PHP/Blade, and more via `mason.nvim`.
- 🏎️ **Next-Gen Completion**: Powered by `blink.cmp` for ultra-fast, fuzzy completions.
- 🎨 **Dynamic Theme System**: Persistent theme switcher with support for Catppuccin, TokyoNight, Rose Pine, Gruvbox, and Everforest.
- 🔍 **Powerful Search**: Fuzzy finding with `Telescope.nvim`.
- 🌲 **Syntax Highlighting**: Enhanced code awareness with `Treesitter`.
- 🛠️ **Formatting & Linting**: Integrated `conform.nvim` and `nvim-lint`.
- 📂 **File Explorer**: `NvimTree` with a clean, responsive layout.

## 📋 Requirements

- **Neovim 0.11+**: Built for the latest features.
- **Nerd Fonts**: (e.g., JetBrainsMono Nerd Font) for icons.
- **External Tools**: `ripgrep`, `fd`, `fzf` (optional but recommended).
- **Node.js/npm/pnpm**: Required for many LSPs (Lovelace, Volar, etc.).

## 🚀 Installation

1. **Backup your current config**:

   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Clone this repository**:

   ```bash
   git clone <repo-url> ~/.config/nvim
   ```

3. **Start Neovim**:
   Plugins will automatically install on the first run.

## 📂 Structure

- `init.lua`: Main entry point.
- `lua/core/`: Core settings and custom logic.
  - `options.lua`: Global Neovim options.
  - `keymaps.lua`: Global and LSP keybindings.
  - `theme.lua`: Advanced theme management and persistence.
  - `lazy.lua`: Plugin manager setup.
- `lua/plugins/`: Modular plugin configurations.

## ⌨️ Keybindings

The leader key is set to **`Space`**.

| Action                  | Mapping      |
| :---------------------- | :----------- |
| **Explorer**            | `<leader>e`  |
| **Find Files**          | `<leader>ff` |
| **Live Grep**           | `<leader>fg` |
| **Change Theme**        | `<leader>ct` |
| **Toggle Dark/Light**   | `<leader>tm` |
| **Toggle Transparency** | `<leader>tt` |

### LSP Keybindings (Active in LSP Buffers)

| Action                | Mapping           |
| :-------------------- | :---------------- |
| **Go to Definition**  | `gd`              |
| **Hover Information** | `<leader><space>` |
| **Rename Symbol**     | `<leader>rn`      |
| **Code Action**       | `<leader>ca`      |
| **Find References**   | `gr`              |
| **Format File**       | `<leader>f`       |
| **Show Diagnostics**  | `<leader>d`       |

### Completion (Blink.cmp)

- `<CR>`: Accept completion.
- `<C-j>`: Next item.
- `<C-k>`: Previous item.

---

_Maintained with by [Ryan](https://github.com/rybalidoy)_
