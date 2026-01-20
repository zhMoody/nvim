local lualine = require('lualine')

-- Gruvbox Material Colors
local colors = {
  bg       = '#282828',
  fg       = '#a89984',
  yellow   = '#d8a657',
  cyan     = '#89b482',
  darkblue = '#081633',
  green    = '#a9b665',
  orange   = '#e78a4e',
  violet   = '#d3869b',
  magenta  = '#d3869b',
  blue     = '#7daea3',
  red      = '#ea6962',
  dark     = '#1d2021', -- 深色背景，用于胶囊内部文字
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
}

local config = {
  options = {
    component_separators = '',
    section_separators = '',
    theme = {
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
    globalstatus = true,
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

-- === 左侧组件 ===

-- 1. 左侧圆头
ins_left {
  function()
    -- 根据模式改变左侧圆头的颜色
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    vim.api.nvim_command('hi! LualineModeHead guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. colors.bg)
    return ''
  end,
  color = 'LualineModeHead',
  padding = { left = 0, right = 0 }, -- 紧贴
}

-- 2. 模式图标 (胶囊内部)
ins_left {
  function()
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    -- 背景色跟随模式，前景色为深色
    vim.api.nvim_command(
      "hi! LualineModeMain guifg="
        .. colors.dark
        .. " guibg="
        .. (mode_color[vim.fn.mode()] or colors.red)
        .. " gui=bold"
    )

    local f_icons = {
      unix = "",
      dos = "",
      mac = "",
    }
    return " " .. (f_icons[vim.bo.fileformat] or "")
  end,
  color = "LualineModeMain",
  padding = { right = 1 },
}

-- 3. 左侧收尾 (改成切角)
ins_left {
  function()
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      ["\22"] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      ["\19"] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.red,
    }
    vim.api.nvim_command(
      "hi! LualineModeTail guifg="
        .. (mode_color[vim.fn.mode()] or colors.red)
        .. " guibg="
        .. colors.bg
    )
    return ""
  end,
  color = "LualineModeTail",
  padding = { left = 0, right = 1 },
}

-- 4. 文件名
ins_left {
  "filename",
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, bg = colors.dark, gui = "bold" },
  separator = { left = "", right = "" },
  path = 1,
}

ins_left {
  "filesize",
  cond = conditions.buffer_not_empty,
  color = { fg = colors.fg, bg = colors.dark, gui = "bold" },
  separator = { left = "", right = "" },
}

-- 5. Git 分支
ins_left {
  "branch",
  icon = "",
  color = { fg = colors.violet, bg = colors.dark, gui = "bold" },
  separator = { left = "", right = "" },
}

-- 6. Git 状态
ins_left {
  "diff",
  source = function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end,
  symbols = { added = " ", modified = "󰏬 ", removed = " " },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  color = { bg = colors.dark },
  separator = { left = "", right = "" },
  cond = conditions.hide_in_width,
}

ins_left {
  function()
    return "%="
  end,
}

-- === 右侧组件 ===
ins_right {
  "searchcount",
  color = { fg = colors.yellow, bg = colors.dark, gui = "bold" },
  separator = { left = "", right = "" },
}

ins_right {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    error = { fg = colors.red },
    warn = { fg = colors.yellow },
    info = { fg = colors.cyan },
  },
  color = { bg = colors.dark },
  separator = { left = "", right = "" },
}

ins_right {
  function()
    return require("lsp-progress").progress()
  end,
  color = { fg = colors.cyan, bg = colors.dark, gui = "bold" },
  separator = { left = "", right = "" },
}

ins_right {
  function()
    local buf_ft =
      vim.api.nvim_get_option_value("filetype", { scope = "local" })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
      return "No LSP"
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return "No LSP"
  end,
  icon = "󰄭",
  color = { fg = colors.blue, bg = colors.dark, gui = "bold" },
  separator = { left = "", right = "" },
}

ins_right {
  "encoding",
  fmt = string.upper,
  color = { fg = colors.green, bg = colors.dark, gui = "bold" },
  separator = { left = "", right = "" },
}

ins_right {
  "location",
  color = { fg = colors.fg, bg = colors.dark, gui = "bold" },
  separator = { left = "", right = "" },
}

ins_right {
  "progress",
  color = { fg = colors.fg, bg = colors.dark, gui = "bold" },
  separator = { left = "", right = "" },
}

ins_right {
  function()
    return ""
  end,
  color = { fg = colors.blue, bg = colors.bg },
  padding = { left = 1, right = 0 },
}

ins_right {
  function()
    return os.date "%H:%M "
  end,
  icon = "",
  color = { fg = colors.dark, bg = colors.blue, gui = "bold" },
}

lualine.setup(config)
