local config = require("config")
local M = {}

M.registry = {
  -- ── 暗色 ──────────────────────────────────────
  gruvbox = {
    colorscheme = "gruvbox", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
    setup = function() require("themes.gruvbox") end,
  },
  everforest = {
    colorscheme = "everforest", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  catppuccin = {
    colorscheme = "catppuccin", background = "dark", type = "dark",
    statusline = "evil", tabline = "gruvbox_modern",
    setup = function() require("catppuccin").setup({ flavour = "macchiato" }) end,
  },
  zephyr = {
    colorscheme = "zephyr", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  tokyonight = {
    colorscheme = "tokyonight", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
    setup = function() require("tokyonight").setup({ style = "night" }) end,
  },
  rosepine = {
    colorscheme = "rose-pine", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  kanagawa = {
    colorscheme = "kanagawa", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
    setup = function() require("kanagawa").setup({ theme = "wave" }) end,
  },
  nightfox = {
    colorscheme = "nightfox", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  dracula = {
    colorscheme = "dracula", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  nord = {
    colorscheme = "nord", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  sonokai = {
    colorscheme = "sonokai", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  onedark = {
    colorscheme = "onedark", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  ["github-dark"] = {
    colorscheme = "github_dark", background = "dark", type = "dark",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },

  -- ── 亮色 ──────────────────────────────────────
  ["everforest-light"] = {
    colorscheme = "everforest", background = "light", type = "light",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  latte = {
    colorscheme = "catppuccin", background = "light", type = "light",
    statusline = "evil", tabline = "gruvbox_modern",
    setup = function() require("catppuccin").setup({ flavour = "latte" }) end,
  },
  ["tokyonight-day"] = {
    colorscheme = "tokyonight", background = "light", type = "light",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
    setup = function() require("tokyonight").setup({ style = "day" }) end,
  },
  ["rosepine-dawn"] = {
    colorscheme = "rose-pine", background = "light", type = "light",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
    setup = function() require("rose-pine").setup({ variant = "dawn" }) end,
  },
  ["kanagawa-lotus"] = {
    colorscheme = "kanagawa", background = "light", type = "light",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
    setup = function() require("kanagawa").setup({ theme = "lotus" }) end,
  },
  dayfox = {
    colorscheme = "dayfox", background = "light", type = "light",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  dawnfox = {
    colorscheme = "dawnfox", background = "light", type = "light",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
  ["github-light"] = {
    colorscheme = "github_light", background = "light", type = "light",
    statusline = "gruvbox_modern", tabline = "gruvbox_modern",
  },
}

M.current = config.colorscheme or "gruvbox"

-- 主题持久化文件
local state_file = vim.fn.stdpath("config") .. "/.theme"

local function save_state(name)
  pcall(vim.fn.writefile, { name }, state_file)
end

-- 先读持久化文件，有则覆盖启动主题
local saved = (pcall(vim.fn.readfile, state_file) and vim.fn.readfile(state_file) or {})[1]
if saved and M.registry[saved] then
  config.colorscheme = saved
  M.current = saved
end

-- 应用指定主题
function M.apply(name)
  local entry = M.registry[name]
  if not entry then return end

  config.colorscheme = name
  vim.o.background = entry.background

  -- 前置配置（风味选择）
  if entry.setup then
    pcall(entry.setup)
  end

  pcall(vim.cmd.colorscheme, entry.colorscheme)

  -- 后处理：欢迎页颜色
  vim.schedule(function()
    local function fg(name, fallback)
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
      return ok and hl.fg and string.format("#%06x", hl.fg) or fallback
    end
    local map = {
      GruvboxOrange  = fg("Constant", "#d19a66"),
      GruvboxYellow  = fg("Identifier", "#e5c07b"),
      GruvboxGreen   = fg("String", "#98c379"),
      GruvboxAqua    = fg("Type", "#56b6c2"),
      GruvboxBlue    = fg("Function", "#61afef"),
      GruvboxPurple  = fg("PreProc", "#c678dd"),
    }
    for group, color in pairs(map) do
      pcall(vim.api.nvim_set_hl, 0, group, { fg = color })
    end

    -- 保证 TabLine 背景透明
    pcall(vim.api.nvim_set_hl, 0, "TabLineFill", { bg = "NONE" })
  end)

  M.current = name
  save_state(name)
  vim.g.python3_host_prog = config.python3_host_prog or "/usr/bin/python3"
end

-- 选择器
function M.picker()
  local dark_items, light_items = {}, {}
  for name, e in pairs(M.registry) do
    local item = { name = name, type = e.type or "dark" }
    if e.type == "light" then table.insert(light_items, item)
    else table.insert(dark_items, item) end
  end
  table.sort(dark_items, function(a, b) return a.name < b.name end)
  table.sort(light_items, function(a, b) return a.name < b.name end)

  vim.ui.select(vim.list_extend(dark_items, light_items), {
    prompt = "󰉼 选择主题",
    format_item = function(item)
      local mark = item.type == "light" and "☀️" or "🌙"
      local check = (item.name == M.current) and "  " or "   "
      return mark .. " " .. item.name .. check
    end,
  }, function(item)
    if item then
      M.apply(item.name)
      vim.notify("主题已切换: " .. item.name, vim.log.levels.INFO)
    end
  end)
end

vim.api.nvim_create_user_command("Theme", M.picker, {})
vim.keymap.set("n", "<localleader>c", M.picker, { desc = "切换主题" })

vim.schedule(function()
  M.apply(M.current)
end)

function M.get_statusline_theme()
  local theme = M.registry[M.current]
  return theme and theme.statusline or "gruvbox_modern"
end

function M.get_tabline_theme()
  local theme = M.registry[M.current]
  return theme and theme.tabline or "gruvbox_modern"
end

return M
