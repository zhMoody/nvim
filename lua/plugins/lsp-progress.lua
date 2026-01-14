require("lsp-progress").setup {
  client_format = function(client_name, spinner, series_messages)
    if #series_messages == 0 then
      return nil
    end
    -- 只返回 spinner，不返回具体消息，因为具体消息在右下角 Noice 看
    return {
      name = client_name,
      body = spinner,
    }
  end,

  format = function(client_messages)
    -- 如果有任何消息，直接返回一个统一的 Loading 状态
    if #client_messages > 0 then
      -- 这里的 client_messages[1].body 就是那个旋转的骰子
      -- 我们强制只取第一个，这样无论有几个任务，底栏永远只显示一个图标
      return client_messages[1].body .. " Processing..."
    end
    return ""
  end,
}