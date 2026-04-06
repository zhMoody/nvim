local wk = require "which-key"

wk.add {
  {
    "<leader>;",
    "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
    desc = "注释",
  },
  { "<leader>a", group = "代码操作" },
  {
    "<leader>ab",
    function()
      require("snacks").picker.buffers()
    end,
    desc = "搜索缓冲区",
  },
  {
    "<leader>ag",
    function()
      require("snacks").picker.grep()
    end,
    desc = "搜索关键字",
  },
  { "<leader>s", group = "搜索" },
  { "<leader>sc", ":nohlsearch<CR>", desc = "清除高亮" },
  { "<leader>b", group = "缓冲区" },
  { "<leader>bk", ":bw<CR>", desc = "关闭缓冲区" },
  { "<leader>d", group = "调试器" },
  {
    "<leader>fd",
    function()
      require("snacks").picker.files()
    end,
    desc = "查找文件",
  },
  { "<leader>dc", desc = "继续" },
  { "<leader>dh", desc = "帮助" },
  { "<leader>di", desc = "步入" },
  { "<leader>dj", desc = "步过" },
  { "<leader>do", desc = "步出" },
  { "<leader>dp", desc = "设置断点" },
  { "<leader>dq", desc = "退出" },
  { "<leader>ds", desc = "开始" },
  { "<leader>dt", desc = "切换调试视图" },
  { "<leader>f", group = "文件" },
  { "<leader>fc", "<cmd>NvimTreeCollapse<CR>", desc = "折叠文件树" },
  {
    "<leader>fd",
    function()
      require("snacks").picker.files()
    end,
    desc = "查找文件",
  },
  { "<leader>fr", "<cmd>NvimTreeRefresh<CR>", desc = "刷新文件树" },
  { "<leader>fs", ":update<CR>", desc = "保存" },
  { "<leader>ft", "<cmd>NvimTreeToggle<CR>", desc = "切换文件树" },
  { "<leader>g", group = "Git" },
  { "<leader>gD", desc = "对比差异~" },
  { "<leader>gR", desc = "重置缓冲区" },
  { "<leader>gS", desc = "暂存缓冲区" },
  { "<leader>gb", desc = "显示行提交信息" },
  { "<leader>gd", desc = "对比差异" },
  { "<leader>gp", desc = "预览更改" },
  { "<leader>gr", desc = "重置更改" },
  { "<leader>gs", desc = "暂存更改" },
  { "<leader>gt", desc = "切换行提交信息" },
  { "<leader>gu", desc = "撤销暂存" },
  { "<leader>gx", desc = "切换已删除" },
  { "<leader>l", group = "LSP" },
  { "<leader>lc", desc = "代码操作" },
  { "<leader>lo", "<cmd>Lspsaga outline<CR>", desc = "切换大纲" },
  { "<leader>lr", "<cmd>Lspsaga rename<CR>", desc = "重命名" },
  { "<leader>p", group = "项目" },
  {
    "<leader>pt",
    function()
      require("snacks").picker.projects()
    end,
    desc = "显示最近项目",
  },
  -- { "<leader>s", group = "Search" },
  -- { "<leader>sc", ":nohlsearch<CR>", desc = "Clear Highlight Result" },
  { "<leader>t", group = "终端" },
  { "<leader>tr", desc = "右侧终端" },
  { "<leader>tt", desc = "切换终端" },
  { "<leader>w", group = "窗口" },
  { "<leader>w=", "<C-w>=", desc = "平均分割窗口" },
  { "<leader>wc", "<C-w>c", desc = "关闭当前窗口" },
  {
    "<leader>wh",
    function()
      _G.split_in_terminal_group("h")
    end,
    desc = "水平分割窗口",
  },
  { "<leader>wo", "<C-w>o", desc = "关闭其他窗口" },
  {
    "<leader>wv",
    function()
      _G.split_in_terminal_group("v")
    end,
    desc = "垂直分割窗口",
  },
}

wk.add {
  {
    "<localleader>=",
    "<cmd>lua vim.lsp.buf.format{ async = true }<CR>",
    desc = "格式化",
  },
  { "<localleader>s", group = "Swift" },
  { "<localleader>c", desc = "切换背景" },
  { "<localleader>d", group = "诊断" },
  { "<localleader>dd", desc = "显示行诊断(Vim API)" },
  { "<localleader>dl", desc = "显示行诊断" },
  { "<localleader>dn", desc = "下一个诊断" },
  { "<localleader>dp", desc = "上一个诊断" },
  { "<localleader>dw", desc = "显示光标诊断" },
  { "<localleader>e", "<cmd>Telescope buffers<CR>", desc = "显示缓冲区" },
  { "<localleader>k", "<cmd>bd<CR>", desc = "删除缓冲区" },
  { "<localleader>l", group = "LSP" },
  { "<localleader>lr", "<cmd>LspRestart<CR>", desc = "重启LSP" },
  { "<localleader>n", "<cmd>NerdIcons<CR>", desc = "打开图标选择器" },
  {
    "<localleader>o",
    function()
      require("snacks").picker.files()
    end,
    desc = "打开文件",
  },
  { "<localleader>t", group = "快速修复列表" },
  {
    "<localleader>tt",
    "<cmd>Lspsaga term_toggle<CR>",
    desc = "切换终端",
  },
  {
    "<localleader>tb",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    desc = "缓冲区诊断(Trouble)",
  },
  {
    "<localleader>tx",
    "<cmd>Trouble diagnostics toggle focus=true<cr>",
    desc = "诊断(Trouble)",
  },
}

wk.setup {
  preset = "modern",
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  win = { border = "single" },
  layout = {
    width = { min = 20 },
    spacing = 3,
  },
  triggers = {
    { "<leader>", mode = "n" },
    { "<localleader>", mode = "n" },
  },
}
