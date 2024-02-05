local ls = require("luasnip")

local snip = ls.snippet
-- local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
-- local func = ls.function_node
-- local choice = ls.choice_node
-- local dynamicn = ls.dynamic_node

ls.add_snippets(nil, {
    go = {
        --[[
            func Test<NAME>(t *testing.T) {
                cases := map[string]struct {
                    <>
                }{
                    "<test case>": {
                        <>
                    }
                }

                for name, tc := range cases {
                    t.Run(name, func(t *testing.T){
                        <>
                    })
                }
            }
        ]] --
        snip({
            trig = "td",
            namr = "table_driven_test",
            dscr = "Table driven test",
        }, {
            text "func Test",
            insert(1, "Name"),
            text {
                "(t *testing.T) {",
                "\tcases := map[string]struct {",
                "\t\t",
            },
            insert(2),
            text {
                "",
                "\t}{",
                "\t\t\"",
            },
            insert(3, "test case"),
            text {
                "\": {",
                "\t\t\t",
            },
            insert(4),
            text {
                "",
                "\t\t},",
                "\t}",
                "",
                "\tfor name, tc := range cases {",
                "\t\tt.Run(name, func(t *testing.T) {",
                "\t\t\t",
            },
            insert(0),
            text {
                "",
                "\t\t})",
                "\t}",
                "}",
            },
        })
    },
})
