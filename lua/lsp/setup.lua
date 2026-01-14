require("mason").setup {
  log_level = vim.log.levels.ERROR,
}

local servers = {
  lua_ls = require "lsp.languages.lua",
  -- rust_analyzer = require "lsp.languages.rust",
  clangd = require "lsp.languages.clangd",
  jsonls = require "lsp.languages.json",
  ocamllsp = require "lsp.languages.ocaml",
  hls = require "lsp.languages.haskell",
  sourcekit = require "lsp.languages.swift",
  rescriptls = require "lsp.languages.rescript",
  zls = require "lsp.languages.zig",
  cssls = require "lsp.languages.css",
  html = require "lsp.languages.html",
  emmet_language_server = require "lsp.languages.emmet",
  ts_ls = require "lsp.languages.react",
}

require("mason-lspconfig").setup {
  ensure_installed = vim.tbl_filter(function(key)
    return key ~= "sourcekit"
      and key ~= "flutterls"
      and key ~= "hls"
      and key ~= "ocamllsp"
  end, vim.tbl_keys(servers)),
}

require("mason-tool-installer").setup {
  ensure_installed = {
    "prettier", -- 通用格式化
    "stylua", -- Lua 格式化
  },
}

for key, config in pairs(servers) do
  if config ~= nil and type(config) == "table" then
    vim.lsp.enable(key)
    vim.lsp.config(key, config)
  end
end
