local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

function _G.GetMasonPackagePath(package_name)
  local root = vim.fn.stdpath("data") .. "/mason/packages"
  local path = root .. "/" .. package_name
  if vim.loop.fs_stat(path) then
    return path
  end
  return nil
end
