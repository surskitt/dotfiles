local ls = require("luasnip")
local extras = require("luasnip.extras")

local snip = ls.snippet
-- local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
-- local func = ls.function_node
-- local choice = ls.choice_node
-- local dynamicn = ls.dynamic_node
local rep = extras.rep
-- local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
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

local ifze_text = [=[
if [[ -z "${<var>}" ]] ; then
  echo "Error: <varr> is unset" >>&2
  exit 1
fi

<after>
]=]

local ifze = snip(
    {
        trig = "ifze",
        namr = "bash_ifze",
        dscr = "error if variable does not exist",
    }, fmta(ifze_text, {
        var = insert(1),
        varr = rep(1),
        after = insert(0),
    })
)

return {
    shebang,
    ifze,
}
