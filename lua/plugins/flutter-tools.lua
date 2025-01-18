require("flutter-tools").setup {
  -- 状态栏装饰
  decorations = {
    statusline = {
      app_version = true, -- 是否显示 Flutter 应用版本
      device = true, -- 是否显示当前连接的设备
      project_config = true, -- 是否显示项目配置
    },
  },

  -- 定义如何识别项目根目录的规则
  root_patterns = { ".git", "pubspec.yaml" },

  -- 是否使用 FVM（Flutter Version Management）
  fvm = false,

  -- 控件树指引线的配置
  widget_guides = {
    enabled = false, -- 是否启用控件树指引线
  },

  -- 自动关闭标签的配置
  closing_tags = {
    highlight = "SuccessMsg", -- 关闭标签的高亮样式
    prefix = "->", -- 标签前缀
    priority = 10, -- 优先级
    enabled = true, -- 是否启用关闭标签功能
  },

  -- 开发日志相关设置
  dev_log = {
    enabled = true, -- 是否启用开发日志
    filter = nil, -- 日志过滤条件
    notify_errors = false, -- 是否使用通知显示错误日志
    open_cmd = "vsplit", -- 打开日志窗口的命令，确保命令有效（如 "15split", "vsplit"）
    focus_on_open = true, -- 是否在打开日志窗口时自动聚焦
  },

  -- 开发工具设置
  dev_tools = {
    autostart = false, -- 是否自动启动开发工具
    auto_open_browser = false, -- 是否自动打开浏览器
  },

  -- 大纲视图设置
  outline = {
    open_cmd = "30vnew", -- 打开大纲视图的命令，默认垂直分屏
    auto_open = false, -- 是否自动打开大纲视图
  },

  -- LSP（语言服务器协议）相关设置
  lsp = {
    -- 颜色高亮设置
    color = {
      enabled = false, -- 是否启用 LSP 颜色高亮
      background = false, -- 是否启用背景颜色
      background_color = nil, -- 背景颜色
      foreground = false, -- 是否启用前景颜色
      virtual_text = true, -- 是否启用虚拟文本
      virtual_text_str = "■", -- 虚拟文本内容
    },

    -- LSP 的设置选项
    settings = {
      showTodos = true, -- 是否显示待办事项（TODOs）
      completeFunctionCalls = true, -- 是否自动补全函数调用
      analysisExcludedFolders = { "/path/to/flutter/.pub-cache" }, -- 分析时排除的文件夹
      renameFilesWithClasses = "prompt", -- 重命名类时是否重命名相关文件（'prompt', 'always', 'never'）
      enableSnippets = true, -- 是否启用代码片段
      updateImportsOnRename = true, -- 是否在重命名时更新导入路径
    },
  },
}
