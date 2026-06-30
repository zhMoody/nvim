return {
  "echasnovski/mini.icons",
  lazy = false,
  version = false,
  opts = {},
  config = function()
    require("mini.icons").setup()
    require("mini.icons").mock_nvim_web_devicons()
  end,
}
