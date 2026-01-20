local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- 全局辅助函数：获取 Mason 安装包的路径
-- 这样在各个 LSP 配置文件里就不用写一大串 ugly path 了
function _G.GetMasonPackagePath(package_name)
  local install_root = vim.fn.stdpath "data" .. "/mason/packages"
  local path = install_root .. "/" .. package_name
  if vim.loop.fs_stat(path) then
    return path
  end
  return nil
end
