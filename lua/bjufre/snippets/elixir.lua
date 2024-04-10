local ls = require("luasnip")
local s = ls.snippet
-- local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("elixir", {
  s("tok", fmt([[{{:ok, {}}}]], { i(1, "value") })),
  s("terr", fmt([[{{:error, {}}}]], { i(1, "error") })),
})
