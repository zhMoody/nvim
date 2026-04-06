local function apply_style(win)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].statuscolumn = ""
  vim.wo[win].cursorline = false
  vim.wo[win].cursorcolumn = false
end

-- 新建原生终端放入当前窗口
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

-- 找到第一个普通编辑窗口
local function find_main_win()
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bt = vim.bo[vim.api.nvim_win_get_buf(w)].buftype
    if bt ~= "terminal" and bt ~= "nofile" then
      return w
    end
  end
  return nil
end

-- ── tt：底部终端，原生 split，天然不覆盖 tr ──────────────────────────────

local tt_main = nil   -- { win, buf }
local tt_splits = {}  -- 额外分屏 { win, buf }

local function tt_is_open()
  return tt_main and vim.api.nvim_win_is_valid(tt_main.win)
end

local function tt_in_group()
  if tt_main and vim.api.nvim_win_is_valid(tt_main.win) then
    if vim.api.nvim_get_current_win() == tt_main.win then return true end
  end
  for _, e in ipairs(tt_splits) do
    if vim.api.nvim_win_is_valid(e.win) and vim.api.nvim_get_current_win() == e.win then
      return true
    end
  end
  return false
end

local function tt_toggle()
  if tt_is_open() then
    -- 隐藏：关闭窗口，保留 buf/进程
    for _, e in ipairs(tt_splits) do
      if vim.api.nvim_win_is_valid(e.win) then
        vim.api.nvim_win_close(e.win, false)
        e.win = -1
      end
    end
    vim.api.nvim_win_close(tt_main.win, false)
    tt_main.win = -1
  else
    -- 从主编辑窗口向下 split，天然与 tr 并排不覆盖
    local editor_win = find_main_win()
    if editor_win then
      vim.api.nvim_set_current_win(editor_win)
    end
    vim.cmd("split")
    vim.cmd("resize 15")

    if tt_main and vim.api.nvim_buf_is_valid(tt_main.buf) then
      -- 恢复旧 buf
      vim.api.nvim_win_set_buf(0, tt_main.buf)
      tt_main.win = vim.api.nvim_get_current_win()
      apply_style(tt_main.win)
      vim.cmd("startinsert")
    else
      tt_main = new_native_term()
    end

    -- 恢复额外分屏
    local valid = {}
    for _, e in ipairs(tt_splits) do
      if vim.api.nvim_buf_is_valid(e.buf) then
        table.insert(valid, e)
      end
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

local function tt_add_split(direction)
  vim.cmd(direction == "h" and "vsplit" or "split")
  table.insert(tt_splits, new_native_term())
end

local function tt_remove_buf(buf)
  if tt_main and tt_main.buf == buf then
    if vim.api.nvim_win_is_valid(tt_main.win) then
      vim.api.nvim_win_close(tt_main.win, false)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    tt_main = nil
    return
  end
  local new_splits = {}
  for _, e in ipairs(tt_splits) do
    if e.buf == buf then
      if vim.api.nvim_win_is_valid(e.win) then vim.api.nvim_win_close(e.win, false) end
      if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
    else
      table.insert(new_splits, e)
    end
  end
  tt_splits = new_splits
end

-- ── tr：右侧终端，Snacks 浮动 ─────────────────────────────────────────────

local tr_main_win = -1
local tr_splits = {}

local function tr_is_open()
  return vim.api.nvim_win_is_valid(tr_main_win)
end

local function tr_in_group()
  if vim.api.nvim_get_current_win() == tr_main_win then return true end
  for _, e in ipairs(tr_splits) do
    if e.win == vim.api.nvim_get_current_win() then return true end
  end
  return false
end

local function tr_toggle()
  if tr_is_open() then
    for _, e in ipairs(tr_splits) do
      if vim.api.nvim_win_is_valid(e.win) then
        vim.api.nvim_win_close(e.win, false)
        e.win = -1
      end
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
    -- 恢复分屏
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

local function tr_add_split(direction)
  vim.cmd(direction == "h" and "vsplit" or "split")
  table.insert(tr_splits, new_native_term())
end

local function tr_remove_buf(buf)
  local new_splits = {}
  for _, e in ipairs(tr_splits) do
    if e.buf == buf then
      if vim.api.nvim_win_is_valid(e.win) then vim.api.nvim_win_close(e.win, false) end
      if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
    else
      table.insert(new_splits, e)
    end
  end
  tr_splits = new_splits
end

-- ── 绑定 ──────────────────────────────────────────────────────────────────

vim.api.nvim_create_autocmd("TermClose", {
  callback = function(ev)
    tt_remove_buf(ev.buf)
    tr_remove_buf(ev.buf)
  end,
})

vim.keymap.set({ "n", "t" }, "<leader>tt", tt_toggle, { desc = "切换底部终端" })
vim.keymap.set({ "n", "t" }, "<leader>tr", tr_toggle, { desc = "切换右侧终端" })

_G.split_in_terminal_group = function(direction)
  if tt_in_group() then
    tt_add_split(direction)
  elseif tr_in_group() then
    tr_add_split(direction)
  else
    vim.cmd(direction == "h" and "vsp" or "sp")
  end
end
