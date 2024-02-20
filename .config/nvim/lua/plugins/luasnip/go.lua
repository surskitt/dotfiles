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
local fmta = require("luasnip.extras.fmt").fmta
-- local choice ls.choice_node

table_driven_test_text = [[
func Test<testName>(t *testing.T) {
	cases := map[string]struct {
		<caseFields>
	}{
		"<caseName>": {
			<caseDefs>
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {
			<testBody>
		})
	}
}
]]

local table_driven_test = snip(
    {
        trig = "td",
        namr = "table_driven_test",
        dscr = "Table driven test",
    }, fmta(table_driven_test_text, {
        testName   = insert(1, "Name"),
        caseFields = insert(2),
        caseName   = insert(3, "test case"),
        caseDefs   = insert(4),
        testBody   = insert(0),
    })
)


return {
    table_driven_test
}
