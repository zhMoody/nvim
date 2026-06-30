return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
  config = function()
    local common = require("lang.lsp-handlers")
    local keybindings = require("core.keymaps")

    local flutter_opts = {
      handlers = common.handlers,
      capabilities = common.capabilities,
      flags = common.flags,
      on_attach = function(client, buf)
        common.disableFormat(client)
        common.keybinding(buf)
        keybindings.map_flutter_tools(buf)
      end,
    }

    local ok, flutter_tools = pcall(require, "flutter-tools")
    if ok then
      flutter_tools.setup {
        lsp = flutter_opts,
        ui = {
          border = "single",
          notification_style = "plugin",
        },
        decorations = { statusline = { device = true } },
        outline = { open_cmd = "30vnew", auto_open = false },
      }
    end

    local telescope_ok = pcall(require, "telescope")
    if telescope_ok then
      pcall(vim.cmd, "Telescope flutter")
    end
  end,
}
