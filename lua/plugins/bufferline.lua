local ok, bufferline = pcall(require, "bufferline")
if not ok then
  return
end

local colors = {
  bg = "#282828", -- 整体背景 (bg0)
  bg_sel = "#3c3836", -- 选中背景 (bg1)
  fg = "#928374", -- 未选中文字 (gray)
  fg_sel = "#ebdbb2", -- 选中文字 (fg)
  yellow = "#fabd2f", -- Gruvbox Yellow
  red = "#cc241d", -- Gruvbox Red
  blue = "#458588", -- Gruvbox Blue (Info)
  aqua = "#689d6a", -- Gruvbox Aqua (Hint)
}

bufferline.setup {
  options = {
    mode = "buffers",
    indicator = { style = "none" },
    separator_style = "slope",

    buffer_close_icon = "󰅖",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,

    diagnostics_indicator = function(count, level)
      local icon = level:match "error" and " "
        or (level:match "warning" and " " or "󰋼 ")
      return " " .. icon .. count
    end,

    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true,
      },
    },

    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    enforce_regular_tabs = false,
    always_show_bufferline = true,
  },

  highlights = {
    fill = { bg = colors.bg },
    background = { fg = colors.fg, bg = colors.bg },

    -- 选中状态
    buffer_selected = {
      fg = colors.yellow,
      bg = colors.bg_sel,
      bold = true,
      italic = false,
    },
    buffer_visible = { fg = colors.fg, bg = colors.bg },

    separator = { fg = colors.bg, bg = colors.bg },
    separator_selected = { fg = colors.bg, bg = colors.bg_sel },
    separator_visible = { fg = colors.bg, bg = colors.bg },

    modified = { fg = colors.fg, bg = colors.bg },
    modified_selected = { fg = colors.yellow, bg = colors.bg_sel },

    -- Error
    error = { fg = colors.red, bg = colors.bg },
    error_selected = { fg = colors.red, bg = colors.bg_sel, bold = true },
    error_diagnostic = { fg = colors.red, bg = colors.bg },
    error_diagnostic_selected = { fg = colors.red, bg = colors.bg_sel },

    -- Warning
    warning = { fg = colors.yellow, bg = colors.bg },
    warning_selected = { fg = colors.yellow, bg = colors.bg_sel },
    warning_diagnostic = { fg = colors.yellow, bg = colors.bg },
    warning_diagnostic_selected = { fg = colors.yellow, bg = colors.bg_sel },

    -- Info
    info = { fg = colors.blue, bg = colors.bg },
    info_selected = { fg = colors.blue, bg = colors.bg_sel },
    info_diagnostic = { fg = colors.blue, bg = colors.bg },
    info_diagnostic_selected = { fg = colors.blue, bg = colors.bg_sel },

    -- Hint
    hint = { fg = colors.aqua, bg = colors.bg },
    hint_selected = { fg = colors.aqua, bg = colors.bg_sel },
    hint_diagnostic = { fg = colors.aqua, bg = colors.bg },
    hint_diagnostic_selected = { fg = colors.aqua, bg = colors.bg_sel },
  },
}

