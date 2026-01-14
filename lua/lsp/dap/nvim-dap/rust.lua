local mason_registry = require "mason-registry"
local codelldb = mason_registry.get_package "codelldb"
local adapter

if codelldb:is_installed() then
  local extension_path = codelldb:get_install_path() .. "/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

  if vim.fn.has "win32" == 1 then
    codelldb_path = extension_path .. "adapter\\codelldb.exe"
    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
  end

  adapter = require("rustaceanvim.config").get_codelldb_adapter(
    codelldb_path,
    liblldb_path
  )
end

return {
  adapter = adapter,
}
