local config = require("config")

-- 各语言文件的 LSP 配置
local servers = {
  lua_ls = require("lang.lua"),
  clangd = require("lang.cpp"),
  jsonls = require("lang.json"),
  ocamllsp = require("lang.ocaml"),
  hls = require("lang.haskell"),
  sourcekit = require("lang.swift"),
  zls = require("lang.zig"),
  cssls = require("lang.css"),
  html = require("lang.html"),
  emmet_language_server = require("lang.emmet"),
  ts_ls = require("lang.typescript"),
  vue_ls = require("lang.vue"),
}

require("mason-lspconfig").setup {
  ensure_installed = vim.tbl_filter(function(key)
    return key ~= "sourcekit"
      and key ~= "flutterls"
      and key ~= "hls"
      and key ~= "ocamllsp"
      and key ~= "vue_ls"
  end, vim.tbl_keys(servers)),
}

require("mason-tool-installer").setup {
  ensure_installed = {
    "prettier",
    "stylua",
    "vue-language-server",
  },
}

for key, opts in pairs(servers) do
  if opts and type(opts) == "table" then
    vim.lsp.enable(key)
    vim.lsp.config(key, opts)
  end
end
