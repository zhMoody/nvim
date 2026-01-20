local common = require "lsp.languages.common"

-- 获取 vue-language-server 的路径 (使用全局辅助函数)
local vue_ls_path = GetMasonPackagePath "vue-language-server"
local plugins = {}

if vue_ls_path then
  -- 仅在 vue-language-server 安装目录下寻找插件，且不做任何假设
  local found = vim.fs.find("typescript-plugin", {
    path = vue_ls_path,
    upward = false,
    type = "directory",
    limit = 1,
  })
  
  if found and #found > 0 then
    table.insert(plugins, {
      name = "@vue/typescript-plugin",
      location = found[1],
      languages = { "vue" },
    })
  end
end

local opts = {
  capabilities = common.capabilities,
  flags = common.flags,
  handlers = common.handlers,
  init_options = {
    plugins = plugins,
  },
  on_attach = function(client, buf)
    common.disableFormat(client)
    common.keybinding(buf)
  end,
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
  },
  settings = {
    typescript = {
      preferences = {
        autoClosingTags = true,
      },
    },
    javascript = {
      preferences = {
        autoClosingTags = true,
      },
    },
  },
}
return opts
