local theme = {
  fill = "TabLineFill",
  -- 左侧 Logo 颜色：紫色
  head = { bg = "#907aa9", fg = "#f2e9de", style = "bold" },
  -- 激活 Tab 颜色：砖红色
  current_tab = { bg = "#d75f5f", fg = "#f2e9de", style = "bold" },
  -- 未激活 Tab 颜色：深暗色调，适合暗色主题
  tab = { bg = "#3c3836", fg = "#d75f5f" },
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

local function get_diagnostics(bufid)
  local diagnostics = vim.diagnostic.get(bufid)
  local count = { error = 0, warn = 0, info = 0 }

  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      count.error = count.error + 1
    elseif diagnostic.severity == vim.diagnostic.severity.WARN then
      count.warn = count.warn + 1
    elseif diagnostic.severity == vim.diagnostic.severity.INFO then
      count.info = count.info + 1
    end
  end

  local res = ""
  if count.error > 0 then
    res = res .. "  " .. count.error
  end
  if count.warn > 0 then
    res = res .. "  " .. count.warn
  end
  if count.info > 0 then
    res = res .. "  " .. count.info
  end
  return res
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

        local changed = buf.is_changed() and " ●" or ""
        local diag = get_diagnostics(buf.id)

        return {
          line.sep("", hl, theme.fill),
          icon,
          "",
          name,
          diag,
          changed,

          line.sep("", hl, theme.fill),

          hl = hl,
          margin = " ",
        }
      end),

      line.spacer(),
      hl = theme.fill,

      {
        line.sep("", theme.head, theme.fill),
        { " 󰈚 ", hl = theme.head },
      },
    }
  end,
}
