local ls = require("luasnip")
-- local extras = require("luasnip.extras")

local snip = ls.snippet
-- local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
-- local func = ls.function_node
-- local choice = ls.choice_node
-- local dynamicn = ls.dynamic_node
-- local repeat = extras.repeat
-- local choice ls.choice_node

local shebang = snip(
    {
        trig = "sb",
        namr = "bash_shebang",
        dscr = "Add the bash shebang",
    }, {
        text({ '#!/usr/bin/env bash', '', '' }),
        insert(0)
    }
)

return {
    shebang,
}
