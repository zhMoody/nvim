# nvim config

**NeoVim v11+**

## Need

### Windows (Scoop)
```powershell
# Search & Find (Required by Telescope)
scoop install ripgrep fd

# Git GUI (Required by Snacks.lazygit)
scoop install lazygit

# For Image Preview (snacks.nvim / image.nvim)
scoop install imagemagick

# For Python support (Required by Vimspector, etc.)
pip install pynvim
```

### macOS (Homebrew)
``` bash
# Search & Find (Required by Telescope)
brew install ripgrep fd

# Git GUI (Required by Snacks.lazygit)
brew install lazygit

# For Image Preview (snacks.nvim / image.nvim)
brew install imagemagick

# For Python support (Required by Vimspector, etc.)
pip3 install pynvim --break-system-packages
```

## System Dependencies (Important)

Some language servers (like Haskell, OCaml, Swift) are best installed via system package managers rather than Mason.
Please read [System Requirements](docs/system_requirements.md) for details.

## Must be configured

First of all, create a Lua file named "config.lua" in the `lua` directory.

**Example content:**

```lua
return {
  colorscheme = "everforest",
  background = "dark", -- dark or light
  -- python3_host_prog = "C:\\Python312\\python.exe", -- Optional: Auto-detected if not set
  lua_line = "bubbles",
  ignore = { "rust-analyzer", "hls" },
}
```
