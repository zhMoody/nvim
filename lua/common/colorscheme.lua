local config = require "config"
vim.opt.termguicolors = true

vim.schedule(function()
  local color = config.colorscheme or "everforest"
  local background = config.background or "dark"
  if background == "dark" then
    vim.cmd.colorscheme(color)
  else
    vim.g.colors_name = color
  end
  vim.o.background = background
  if config.python3_host_prog then
    vim.g.python3_host_prog = config.python3_host_prog
  elseif vim.fn.has "win32" == 1 then
    vim.g.python3_host_prog = vim.fn.exepath "python"
  else
    vim.g.python3_host_prog = "/usr/bin/python3"
  end
end)
