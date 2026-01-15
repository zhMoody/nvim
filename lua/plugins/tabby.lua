local theme = {
  -- 关键修改：fill 改为默认背景（透明），这样就是黑色的
  fill = "TabLineFill",
  -- 左侧 Logo 颜色：紫色
  head = { bg = "#907aa9", fg = "#f2e9de", style = "bold" },
  -- 激活 Tab 颜色：砖红色
  current_tab = { bg = "#d75f5f", fg = "#f2e9de", style = "bold" },
  -- 未激活 Tab 颜色：深暗色调，适合暗色主题
  tab = { bg = "#3c3833", fg = "#d75f39" },
  tail = { bg = "TabLineFill", fg = "#907aa9" },
}

local function get_icon(filename)
  if not filename or filename == "" then
    return "󰈚"
  end
  local extension = vim.fn.fnamemodify(filename, ":e")
  local icon = require("nvim-web-devicons").get_icon(
    filename,
    extension,
    { default = true }
  )
  return icon or "󰈚"
end

require("tabby").setup {
  line = function(line)
    return {
      -- 左侧 Logo
      {
        { "  ", hl = theme.head },
        line.sep("", theme.head, theme.fill),
      },

      -- 文件列表
      line.bufs().foreach(function(buf)
        local is_active = buf.is_current()
        local hl = is_active and theme.current_tab or theme.tab
        local icon = get_icon(buf.name())
        local name = buf.name() == "" and "[No Name]"
          or vim.fn.fnamemodify(buf.name(), ":t")

        local changed = buf.is_changed() and "●" or ""

        return {
          -- 左侧切角
          line.sep("", hl, theme.fill),

          -- 内容区域
          "",
          icon,
          " ",
          name,
          "",
          changed,

          -- 右侧切角
          line.sep("", hl, theme.fill),

          -- 样式与间距
          hl = hl,
          margin = " ",
        }
      end),

      line.spacer(),
      hl = theme.fill,
    }
  end,
}
