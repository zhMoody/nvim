local ok, snacks = pcall(require, "snacks")

if ok then
  snacks.setup {
    -- 更好的 UI 输入框
    input = { enabled = true },
    -- 图像预览支持
    image = { enabled = true },
    -- 悬浮终端支持
    terminal = { enabled = true },
    -- 大文件自动优化 (防止卡死)
    bigfile = { enabled = true },
    -- 快速文件处理
    quickfile = { enabled = true },
    -- Lazygit 集成
    lazygit = { 
      enabled = true,
      configure = true, -- 自动生成配置文件
      config = {
        os = {
          editPreset = "nvim-remote", -- 强制使用远程回调模式
        },
        gui = {
          nerdFontsVersion = "3",
        },
        -- 修改键位：用 o 来编辑文件
        keybinding = {
          universal = {
            edit = "o", 
            open = "<c-o>", -- 把原来的系统打开(open)换个键，避免冲突
          },
        },
      },
    },
    -- 单词自动高亮 (可选，替代 vim-illuminate)
    words = { enabled = true },
    -- 禁用 Snacks 自带通知，交由 Noice 统一管理
    notifier = { enabled = false },
  }
end