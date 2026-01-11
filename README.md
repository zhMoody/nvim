# nvim config

**NeoVim v11+**

## Need
``` bash
# Search & Find (Required by Telescope)
brew install ripgrep fd

# For Image Preview (snacks.nvim / image.nvim)
brew install imagemagick

# For Python support
# Note: If using Homebrew Python, you may need --break-system-packages
pip3 install pynvim --break-system-packages
```

## System Dependencies (Important)

Some language servers (like Haskell, OCaml, Swift) are best installed via Homebrew rather than Mason.
Please read [System Requirements](docs/system_requirements.md) for details.

## Must be configured

First of all, create a Lua file named "config.lua" in the `lua` directory, it contains the following content:

```lua
return {
  colorscheme = "everforest",
  background = "light",
  python3_host_prog = "/opt/homebrew/bin/python3",
  lua_line = "bubbles",
  ignore = { "rust-analyzer", "hls" },
}
```
