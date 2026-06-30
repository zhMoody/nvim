return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-telescope/telescope-media-files.nvim",
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup {
      defaults = {
        initial_mode = "insert",
        mappings = require("core.keymaps").telescope_keys,
        vimgrep_arguments = {
          "rg", "--color=never", "--no-heading",
          "--line-number", "--column", "--smart-case",
        },
        pickers = { find_files = { theme = "cursor" } },
        entry_prefix = "  ",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { prompt_position = "bottom", preview_width = 0.5, results_width = 0.87 },
          vertical = { mirror = false },
          width = 0.87, height = 0.80, preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "absolute" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        color_devicons = true,
        use_less = true,
        set_env = { COLORTERM = "truecolor" },
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
      },
      extensions = {
        fzf = { fuzzy = true, override_generic_sorter = false, override_file_sorter = true, case_mode = "smart_case" },
        media_files = { filetypes = { "png", "webp", "jpg", "jpeg" }, find_cmd = "fd" },
      },
    }
  end,
}
