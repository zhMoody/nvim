local ok, snacks = pcall(require, "snacks")

if ok then
  snacks.setup {
    input = {
      enabled = true,
    },
    image = {
      enabled = true,
    },
  }
end
