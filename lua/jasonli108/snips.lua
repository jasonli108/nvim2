local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node

ls.add_snippets('python', { s('main', t('if __name__ == "__main__":'))})
ls.add_snippets('python', { s('init', t('def __init__(self): ' ))})
ls.add_snippets('python', { s('ss', t('ss= s=Solution() ' ))})
ls.add_snippets('python', { s('sprint', t(' print("some:{}, some2:{}".format(arr,r))'))})
