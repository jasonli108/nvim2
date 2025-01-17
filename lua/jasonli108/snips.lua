local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
  s({ trig = "main", name = "main header", desc = "check if __name__ is equal to the __main__" }, {
    t('if __name__ == "__main__":'),
  }),
})

ls.add_snippets("python", {
  s({ trig = "constructor", name = "constructor", desc = "constructor header" }, {
    t({ "", "  " }),
    i(0, "def __init__(self): "),
  }),
})

ls.add_snippets("python", {
  s({ trig = "mainss", name = "main with ss", desc = "main with solution" }, {
    t('if __name__ == "__main__":'),
    t({ "", "    " }),
    i(1, "ss = Solution() "),
    t({ "", "    " }),
    i(1, "expect_result = some val"),
    t({ "", "    " }),
    i(1, "actual_result = ss.function"),
    t({ "", "    " }),
    i(1, "assert actual_result == expect_result"),
  }),
})
