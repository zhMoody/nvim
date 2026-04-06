-- 透明 tabline 背景，营造悬空感
vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })
  end,
})

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
  local icon, _ = require("mini.icons").get("file", filename)
  return icon or "󰈚"
end

-- 获取图标对应的彩色 hl group（背景与 tab 一致）
local function get_icon_hl(filename, tab_bg)
  if not filename or filename == "" then return nil end
  local _, hl_name = require("mini.icons").get("file", filename)
  if not hl_name then return nil end
  local ok, hi = pcall(vim.api.nvim_get_hl, 0, { name = hl_name, link = false })
  if not ok or not hi.fg then return nil end
  local fg = string.format("#%06x", hi.fg)
  local key = "TabbyIcon_" .. hl_name:gsub("[^%w]", "_") .. "_" .. tab_bg:sub(2)
  vim.api.nvim_set_hl(0, key, { fg = fg, bg = tab_bg })
  return key
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
        local tab_bg = is_active and "#d75f5f" or "#3c3836"
        local icon = get_icon(buf.name())
        local icon_hl = get_icon_hl(buf.name(), tab_bg) or hl
        local name = buf.name() == "" and "[No Name]"
          or vim.fn.fnamemodify(buf.name(), ":t")

        local changed = buf.is_changed() and " ●" or ""
        local diag = get_diagnostics(buf.id)

        return {
          line.sep("", hl, theme.fill),
          { icon, hl = icon_hl },
          " ",
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
