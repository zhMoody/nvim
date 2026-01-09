local ok, gruvbox = pcall(require, "gruvbox")

if ok then
  gruvbox.setup {
    terminal_colors = true, -- 按终端的颜色配置
    undercurl = true, -- 波浪线下划线
    underline = true, -- 常规下滑线
    bold = true, -- 启用粗字体显示
    italic = {
      strings = true, -- 字符串是否斜体
      emphasis = true, -- 强调文本是否斜体
      comments = true, -- 注释是否斜体
      operators = false, -- 运算符是否斜体 + - * /
      folds = true, -- 代码折叠处是否斜体
    },
    strikethrough = true, -- 删除线
    invert_selection = false, -- 是否反转所选中文本的颜色
    invert_signs = false, -- 是否反转侧边栏的颜色， git 断点等
    invert_tabline = false, -- 是否反转顶部标签栏的颜色
    inverse = true, -- 全局反色开关
    contrast = "", -- 对比度级别 “hard": 背景更黑, "":默认, "soft":背景偏灰
    palette_overrides = {}, -- 调试版覆盖
    overrides = {}, -- 高亮组覆盖
    dim_inactive = false, -- 暗淡非活跃窗口
    transparent_mode = true, -- 透明模式
  }
end
