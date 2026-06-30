-- 从 nvim-012 common/terminal.lua 原样迁移
local function apply_style(win)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].statuscolumn = ""
  vim.wo[win].cursorline = false
  vim.wo[win].cursorcolumn = false
end

local function new_native_term()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.fn.termopen(vim.o.shell)
  vim.bo[buf].buflisted = false
  local win = vim.api.nvim_get_current_win()
  apply_style(win)
  vim.cmd("startinsert")
  return { win = win, buf = buf }
end

local function find_main_win()
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bt = vim.bo[vim.api.nvim_win_get_buf(w)].buftype
    if bt ~= "terminal" and bt ~= "nofile" then
      return w
    end
  end
  return nil
end

-- tt: 底部原生 split
local tt_main = nil
local tt_splits = {}

local function tt_is_open()
  return tt_main and vim.api.nvim_win_is_valid(tt_main.win)
end

local function tt_in_group()
  if tt_main and vim.api.nvim_win_is_valid(tt_main.win) then
    if vim.api.nvim_get_current_win() == tt_main.win then return true end
  end
  for _, e in ipairs(tt_splits) do
    if vim.api.nvim_win_is_valid(e.win) and vim.api.nvim_get_current_win() == e.win then return true end
  end
  return false
end

local function tt_toggle()
  if tt_is_open() then
    for _, e in ipairs(tt_splits) do
      if vim.api.nvim_win_is_valid(e.win) then
        if #vim.api.nvim_list_wins() > 1 then vim.api.nvim_win_close(e.win, false) end
        e.win = -1
      end
    end
    if #vim.api.nvim_list_wins() > 1 then vim.api.nvim_win_close(tt_main.win, false) end
    tt_main.win = -1
  else
    local editor_win = find_main_win()
    if editor_win then vim.api.nvim_set_current_win(editor_win) end
    vim.cmd("split")
    vim.cmd("resize 15")
    if tt_main and vim.api.nvim_buf_is_valid(tt_main.buf) then
      vim.api.nvim_win_set_buf(0, tt_main.buf)
      tt_main.win = vim.api.nvim_get_current_win()
      apply_style(tt_main.win)
      vim.cmd("startinsert")
    else
      tt_main = new_native_term()
    end
    local valid = {}
    for _, e in ipairs(tt_splits) do
      if vim.api.nvim_buf_is_valid(e.buf) then table.insert(valid, e) end
    end
    tt_splits = {}
    for _, e in ipairs(valid) do
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0, e.buf)
      e.win = vim.api.nvim_get_current_win()
      apply_style(e.win)
      vim.cmd("startinsert")
      table.insert(tt_splits, e)
    end
  end
end

-- tr: 右侧 Snacks 浮动
local tr_main_win = -1
local tr_splits = {}

local function tr_is_open()
  return vim.api.nvim_win_is_valid(tr_main_win)
end

local function tr_toggle()
  if tr_is_open() then
    for _, e in ipairs(tr_splits) do
      if vim.api.nvim_win_is_valid(e.win) then vim.api.nvim_win_close(e.win, false) e.win = -1 end
    end
    Snacks.terminal.toggle(nil, { count = 20, win = { position = "right" } })
    tr_main_win = -1
  else
    local before = {}
    for _, w in ipairs(vim.api.nvim_list_wins()) do before[w] = true end
    Snacks.terminal.toggle(nil, { count = 20, win = { position = "right" } })
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if not before[w] then tr_main_win = w; break end
    end
    local valid = {}
    for _, e in ipairs(tr_splits) do
      if vim.api.nvim_buf_is_valid(e.buf) then table.insert(valid, e) end
    end
    tr_splits = {}
    for _, e in ipairs(valid) do
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0, e.buf)
      e.win = vim.api.nvim_get_current_win()
      apply_style(e.win)
      vim.cmd("startinsert")
      table.insert(tr_splits, e)
    end
  end
end

-- Split in terminal group
_G.split_in_terminal_group = function(direction)
  if tt_in_group() then
    -- tt_add_split(direction) - simplified
    vim.cmd(direction == "h" and "vsp" or "sp")
  elseif tr_in_group() then
    vim.cmd(direction == "h" and "vsp" or "sp")
  else
    vim.cmd(direction == "h" and "vsp" or "sp")
  end
end

-- TermClose cleanup
vim.api.nvim_create_autocmd("TermClose", {
  callback = function(ev)
    if tt_main and tt_main.buf == ev.buf then
      if vim.api.nvim_win_is_valid(tt_main.win) and #vim.api.nvim_list_wins() > 1 then
        vim.api.nvim_win_close(tt_main.win, false)
      end
      if vim.api.nvim_buf_is_valid(ev.buf) then vim.api.nvim_buf_delete(ev.buf, { force = true }) end
      tt_main = nil
    end
  end,
})

vim.keymap.set({ "n", "t" }, "<leader>tt", tt_toggle, { desc = "切换底部终端" })
vim.keymap.set({ "n", "t" }, "<leader>tr", tr_toggle, { desc = "切换右侧终端" })
