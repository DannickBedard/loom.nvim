local constant = require("githelper.borders.constant")

local simple_thick_border = { }
simple_thick_border[constant.CORNER_LEFT_TOP] = "┏"
simple_thick_border[constant.CORNER_RIGHT_TOP] = "┓"
simple_thick_border[constant.CORNER_LEFT_BOTTOM] = "┗"
simple_thick_border[constant.CORNER_RIGHT_BOTTOM] = "┛"
simple_thick_border[constant.SIDE] = "┃"
simple_thick_border[constant.SIDE_BOTTOM] = "━"
simple_thick_border[constant.SPLIT_TOP] = "┳"
simple_thick_border[constant.SPLIT_BOTTOM] = "┻"
simple_thick_border[constant.SPLIT_MIDLE] = "╋"
simple_thick_border[constant.SPLIT_LEFT_SIDE] = "┣"
simple_thick_border[constant.SPLIT_RIGHT_SIDE] = "┫"

return simple_thick_border
