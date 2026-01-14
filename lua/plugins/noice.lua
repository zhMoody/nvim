local ok, noice = pcall(require, "noice")
if not ok then
  return
end

noice.setup {
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    progress = {
      enabled = false,
    },
  },
  presets = {
    bottom_search = false, -- 如果为 true，搜索框在底部；false 则在中间
    command_palette = true, -- 将 cmdline 和 popupmenu 放在中间
    long_message_to_split = true, -- 长消息发送到 split
    inc_rename = false, -- 启用输入重命名时的预览
    lsp_doc_border = true, -- 给 lsp 文档加边框
  },
  cmdline = {
    view = "cmdline_popup",
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
  },
  views = {
    cmdline_popup = {
      position = {
        row = "20%",
        col = "50%",
      },
      size = {
        width = 60,
        height = "auto",
      },
    },
    popupmenu = {
      relative = "editor",
      position = {
        row = 8,
        col = "50%",
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
      },
    },
  },
}

-- 配置 Notify
local notify_ok, notify = pcall(require, "notify")
if notify_ok then
  notify.setup {
    background_colour = "#000000",
    stages = "slide", -- 动画效果 "fade", "slide", "static"
    timeout = 3000,
  }
  vim.notify = notify
end
