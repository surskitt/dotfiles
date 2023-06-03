local autocrop = function(factor)
    local vid_w = mp.get_property("width")
    local vid_h = mp.get_property("height")

    local w = vid_w / factor
    local remainder = vid_w - w
    local x = remainder / 2

    local h = vid_h
    local y = vid_h

    local ok, err = mp.command(string.format("no-osd vf add @%s:crop=%s:%s:%s:%s", 'autocrop', w, h, x, y))

    if not ok then
        mp.osd_message("Cropping failed")
    end
end

local reset = function()
    autocrop(1)
end

local half = function()
    autocrop(2)
end

local third = function()
    autocrop(3)
end

local fourth = function()
    autocrop(4)
end

local twothird = function()
    autocrop(1.5)
end

mp.add_key_binding("Ctrl+1", "autocrop_reset", reset)
mp.add_key_binding("Ctrl+2", "autocrop_half", half)
mp.add_key_binding("Ctrl+3", "autocrop_third", third)
mp.add_key_binding("Ctrl+4", "autocrop_fourth", fourth)
mp.add_key_binding("Ctrl+5", "autocrop_twothird", twothird)
