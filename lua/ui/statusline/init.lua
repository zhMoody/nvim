return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "echasnovski/mini.icons" },
  opts = function()
    local theme_name = require("themes").get_statusline_theme()
    local ok, mod = pcall(require, "ui.statusline." .. theme_name)
    if ok then
      return mod
    end
    return {}
  end,
}
