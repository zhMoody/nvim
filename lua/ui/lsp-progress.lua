return {
  "linrongbin16/lsp-progress.nvim",
  opts = {
    client_format = function(client_name, spinner, series_messages)
      if #series_messages == 0 then
        return nil
      end
      return { name = client_name, body = spinner }
    end,
    format = function(client_messages)
      if #client_messages > 0 then
        return client_messages[1].body .. " Processing..."
      end
      return ""
    end,
  },
}
