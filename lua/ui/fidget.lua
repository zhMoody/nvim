return {
  "j-hui/fidget.nvim",
  tag = "v1.4.0",
  opts = function()
    local config = require("config")

    vim.fn.sign_define("fidget.Done", { text = "✔" })
    vim.fn.sign_define("fidget.Active", { text = "󰇊" })

    return {
      progress = {
        ignore = config.ignore or { "rust-analyzer", "hls", "lua_ls" },
        display = {
          progress_icon = { pattern = "dots", period = 1 },
          done_icon = "✔",
          overrides = {
            rust_analyzer = { name = "rust-analyzer" },
            lua_ls = { name = "lua-ls" },
          },
        },
      },
      notification = {
        override_vim_notify = true,
        filter = vim.log.levels.INFO,
        window = {
          align = "bottom",
          border = "single",
          relative = "win",
        },
      },
    }
  end,
}
