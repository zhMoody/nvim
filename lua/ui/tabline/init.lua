return {
  "nanozuki/tabby.nvim",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    line = function(line)
      local function h(name)
        local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = name })
        return ok and h or {}
      end
      local function hex(c) return c and string.format("#%06x", c) or nil end

      -- 判断当前 colorscheme
      local is_gruvbox = vim.g.colors_name and vim.g.colors_name:find("gruvbox")

      local theme
      if is_gruvbox then
        -- gruvbox 保留原色
        theme = {
          fill = "TabLineFill",
          head = { bg = "#907aa9", fg = "#f2e9de", style = "bold" },
          current_tab = { bg = "#d75f5f", fg = "#f2e9de", style = "bold" },
          tab = { bg = "#3c3836", fg = "#d75f5f" },
          tail = { bg = "#907aa9", fg = "#f2e9de" },
        }
      else
        -- 其他主题从高亮组取色
        local tabline = h("TabLine")
        local tabsel  = h("TabLineSel")
        local fill    = h("TabLineFill")
        local norm    = h("Normal")

        local sel_bg = hex(tabsel.bg) or "#504945"
        local sel_fg = hex(tabsel.fg) or hex(norm.fg) or "#ebdbb2"
        local tab_bg = hex(tabline.bg) or hex(fill.bg) or "NONE"
        local tab_fg = hex(tabline.fg) or "#928374"

        theme = {
          fill = "TabLineFill",
          head = { bg = sel_bg, fg = sel_fg, style = "bold" },
          current_tab = { bg = sel_bg, fg = sel_fg, style = "bold" },
          tab = { bg = tab_bg, fg = tab_fg },
          tail = { bg = sel_bg, fg = sel_fg },
        }
      end

      -- 透明背景
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE" })

      local function get_icon(filename)
        if not filename or filename == "" then return "󰈚" end
        local icon, _ = require("mini.icons").get("file", filename)
        return icon or "󰈚"
      end

      local function get_icon_hl(filename, tab_bg)
        if not filename or filename == "" then return nil end
        local _, hl_name = require("mini.icons").get("file", filename)
        if not hl_name then return nil end
        local ok, hi = pcall(vim.api.nvim_get_hl, 0, { name = hl_name, link = false })
        if not ok or not hi.fg then return nil end
        local fg = string.format("#%06x", hi.fg)
        local key = "TabbyIcon_" .. hl_name:gsub("[^%w]", "_") .. "_" .. (tab_bg:gsub("#", ""))
        vim.api.nvim_set_hl(0, key, { fg = fg, bg = tab_bg })
        return key
      end

      local function get_diagnostics(bufid)
        local d = vim.diagnostic.get(bufid)
        local err, warn, info = 0, 0, 0
        for _, v in ipairs(d) do
          if v.severity == vim.diagnostic.severity.ERROR then err = err + 1
          elseif v.severity == vim.diagnostic.severity.WARN then warn = warn + 1
          elseif v.severity == vim.diagnostic.severity.INFO then info = info + 1 end
        end
        local r = ""
        if err > 0 then r = r .. " " .. err end
        if warn > 0 then r = r .. " " .. warn end
        if info > 0 then r = r .. " " .. info end
        return r
      end

      return {
        {
          { "  ", hl = theme.head },
          line.sep("", theme.head, theme.fill),
        },
        line.bufs().foreach(function(buf)
          local is_active = buf.is_current()
          local hl = is_active and theme.current_tab or theme.tab
          local tab_bg = hl.bg
          local icon = get_icon(buf.name())
          local icon_hl = get_icon_hl(buf.name(), hl.bg) or hl
          local name = buf.name() == "" and "[No Name]" or vim.fn.fnamemodify(buf.name(), ":t")
          local changed = buf.is_changed() and " ●" or ""
          local diag = get_diagnostics(buf.id)
          return {
            line.sep("", hl, theme.fill),
            { icon, hl = icon_hl },
            " ", name, changed,
            diag ~= "" and (" " .. diag) or "",
            line.sep("", hl, theme.fill),
            hl = hl, margin = " ",
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
  },
}
