local ls = require("luasnip")
-- local extras = require("luasnip.extras")

local snip = ls.snippet
-- local node = ls.snippet_node
-- local text = ls.text_node
local insert = ls.insert_node
-- local func = ls.function_node
-- local choice = ls.choice_node
-- local dynamicn = ls.dynamic_node
-- local repeat = extras.repeat
local fmt = require("luasnip.extras.fmt").fmt
-- local choice ls.choice_node

local table_driven_test_fmt = [[
func Test{}(t *testing.T) {{
	cases := map[string]struct {{
		{}
	}}{{
		"{}": {{
			{}
		}},
	}}

	for name, tc := range cases {{
		t.Run(name, func(t *testing.T) {{
			{}
		}})
	}}
}}
]]

local table_driven_test = snip(
    {
        trig = "td",
        namr = "table_driven_test",
        dscr = "Table driven test",
    }, fmt(table_driven_test_fmt, {
        insert(1, "Name"),
        insert(2),
        insert(3, "test case"),
        insert(4),
        insert(0),
    })
)

return {
    table_driven_test
}
