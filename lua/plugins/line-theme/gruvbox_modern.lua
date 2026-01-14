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
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
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

ins_left {
  function() return '▊' end,
  color = { fg = colors.blue },
  padding = { left = 0, right = 1 },
}

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
    vim.api.nvim_command('hi! LualineMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. colors.bg)
    return ''
  end,
  color = 'LualineMode',
  padding = { right = 1 },
}

-- 完整文件路径 (相对路径)
ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, gui = 'bold' },
  path = 1, -- 0 = 仅文件名, 1 = 相对路径, 2 = 绝对路径
}

-- Git 分支
ins_left {
  'branch',
  icon = '',
  color = { fg = colors.violet, gui = 'bold' },
}

-- Git 状态 (新增/修改/删除)
ins_left {
  'diff',
  -- 明确指定 source，确保能读到数据
  source = function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed
      }
    end
  end,
  symbols = { added = ' ', modified = '󰏬 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_left {
  function() return '%=' end,
}

-- === 右侧组件 ===

-- 诊断信息 (错误/警告个数)
ins_right {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    error = { fg = colors.red },
    warn = { fg = colors.yellow },
    info = { fg = colors.cyan },
  },
}

-- LSP 进度 (加载动画/骰子)
ins_right {
  function()
    return require('lsp-progress').progress()
  end,
  color = { fg = colors.cyan, gui = 'bold' },
}

-- 修复弃用警告并简化 LSP 显示

ins_right {
  function()
    local buf_ft = vim.api.nvim_get_option_value('filetype', { scope = 'local' })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
      return 'No LSP'
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return 'No LSP'
  end,
  icon = '󰄭',
  color = { fg = colors.blue, gui = 'bold' },
}

ins_right { 'location' }

ins_right { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_right {
  function() return '▊' end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

lualine.setup(config)
