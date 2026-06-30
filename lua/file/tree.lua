local function on_attach(bufnr)
  local api = require("nvim-tree.api")
  local function km(desc)
    return { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "nvim-tree: " .. desc }
  end

  vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, km "CD")
  vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, km "Open: In Place")
  vim.keymap.set("n", "<C-k>", api.node.show_info_popup, km "Info")
  vim.keymap.set("n", "<C-r>", api.fs.rename_sub, km "Rename: Omit Filename")
  vim.keymap.set("n", "<C-t>", api.node.open.tab, km "Open: New Tab")
  vim.keymap.set("n", "<C-v>", api.node.open.vertical, km "Open: Vertical Split")
  vim.keymap.set("n", "<C-x>", api.node.open.horizontal, km "Open: Horizontal Split")
  vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, km "Close Directory")
  vim.keymap.set("n", "<CR>", api.node.open.edit, km "Open")
  vim.keymap.set("n", "<Tab>", api.node.open.preview, km "Open Preview")
  vim.keymap.set("n", ">", api.node.navigate.sibling.next, km "Next Sibling")
  vim.keymap.set("n", "<", api.node.navigate.sibling.prev, km "Previous Sibling")
  vim.keymap.set("n", ".", api.node.run.cmd, km "Run Command")
  vim.keymap.set("n", "-", api.tree.change_root_to_parent, km "Up")
  vim.keymap.set("n", "a", api.fs.create, km "Create")
  vim.keymap.set("n", "bmv", api.marks.bulk.move, km "Move Bookmarked")
  vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, km "Toggle No Buffer")
  vim.keymap.set("n", "c", api.fs.copy.node, km "Copy")
  vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, km "Toggle Git Clean")
  vim.keymap.set("n", "[c", api.node.navigate.git.prev, km "Prev Git")
  vim.keymap.set("n", "]c", api.node.navigate.git.next, km "Next Git")
  vim.keymap.set("n", "d", api.fs.remove, km "Delete")
  vim.keymap.set("n", "D", api.fs.trash, km "Trash")
  vim.keymap.set("n", "E", api.tree.expand_all, km "Expand All")
  vim.keymap.set("n", "e", api.fs.rename_basename, km "Rename: Basename")
  vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, km "Next Diagnostic")
  vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, km "Prev Diagnostic")
  vim.keymap.set("n", "F", api.live_filter.clear, km "Clean Filter")
  vim.keymap.set("n", "f", api.live_filter.start, km "Filter")
  vim.keymap.set("n", "g?", api.tree.toggle_help, km "Help")
  vim.keymap.set("n", "gy", api.fs.copy.absolute_path, km "Copy Absolute Path")
  vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, km "Toggle Dotfiles")
  vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, km "Toggle Git Ignore")
  vim.keymap.set("n", "J", api.node.navigate.sibling.last, km "Last Sibling")
  vim.keymap.set("n", "K", api.node.navigate.sibling.first, km "First Sibling")
  vim.keymap.set("n", "m", api.marks.toggle, km "Toggle Bookmark")
  vim.keymap.set("n", "o", api.node.open.edit, km "Open")
  vim.keymap.set("n", "O", api.node.open.no_window_picker, km "Open: No Window Picker")
  vim.keymap.set("n", "p", api.fs.paste, km "Paste")
  vim.keymap.set("n", "P", api.node.navigate.parent, km "Parent Directory")
  vim.keymap.set("n", "q", api.tree.close, km "Close")
  vim.keymap.set("n", "r", api.fs.rename, km "Rename")
  vim.keymap.set("n", "R", api.tree.reload, km "Refresh")
  vim.keymap.set("n", "s", api.node.run.system, km "Run System")
  vim.keymap.set("n", "S", api.tree.search_node, km "Search")
  vim.keymap.set("n", "U", api.tree.toggle_custom_filter, km "Toggle Hidden")
  vim.keymap.set("n", "W", api.tree.collapse_all, km "Collapse")
  vim.keymap.set("n", "x", api.fs.cut, km "Cut")
  vim.keymap.set("n", "y", api.fs.copy.filename, km "Copy Name")
  vim.keymap.set("n", "Y", api.fs.copy.relative_path, km "Copy Relative Path")
  vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, km "Open")
  vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, km "CD")
  vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, km "Toggle Dotfiles")
end

return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeRefresh" },
  opts = {
    git = { enable = true, ignore = true, timeout = 5000 },
    update_cwd = false,
    update_focused_file = { enable = true, update_cwd = false },
    view = {
      float = {
        enable = true,
        open_win_config = function()
          local screen_w = vim.opt.columns:get()
          local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
          local window_w = screen_w * 0.8
          local window_h = screen_h * 0.7
          return {
            border = "single",
            relative = "editor",
            row = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get(),
            col = (screen_w - window_w) / 2,
            width = math.floor(window_w),
            height = math.floor(window_h),
          }
        end,
      },
    },
    renderer = {
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
        glyphs = {
          folder = {
            arrow_closed = "",
            arrow_open = "",
          },
        },
      },
    },
    on_attach = on_attach,
  },
}
