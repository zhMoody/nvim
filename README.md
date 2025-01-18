# nvim config
**NeoVim v10+**
## Must be configured
First of all, create a Lua file named "config.lua" in the `lua` directory, it contains the following content:

need pynvim

```shell
    pip install pynvim
    
    which python3
```


```lua
return {
  colorscheme = "gruvbox",
  background = "light",
  python3_host_prog = "/usr/bin/python3",
}
```
