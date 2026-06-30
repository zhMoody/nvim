return {
  "ahmedkhalf/project.nvim",
  opts = {
    detection_methods = { "pattern" },
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".sln" },
  },
  config = function()
    vim.g.nvim_respect_buf_cwd = 1
    local status, telescope = pcall(require, "telescope")
    if status then
      pcall(telescope.load_extension, "projects")
    end
  end,
}
