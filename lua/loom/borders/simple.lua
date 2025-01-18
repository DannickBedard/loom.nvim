local constant = require("githelper.borders.constant")

local simple_border = { }
simple_border[constant.CORNER_LEFT_TOP] = "┌"
simple_border[constant.CORNER_RIGHT_TOP] = "┐"
simple_border[constant.CORNER_LEFT_BOTTOM] = "└"
simple_border[constant.CORNER_RIGHT_BOTTOM] = "┘"
simple_border[constant.SIDE] = "│"
simple_border[constant.SIDE_BOTTOM] = "─"
simple_border[constant.SPLIT_TOP] = "┬"
simple_border[constant.SPLIT_BOTTOM] = "┴"
simple_border[constant.SPLIT_MIDLE] = "┼"
simple_border[constant.SPLIT_LEFT_SIDE] = "├"
simple_border[constant.SPLIT_RIGHT_SIDE] = "┤"
simple_border[constant.CORNER_LEFT_TOP_ROUNDED] = "╭"
simple_border[constant.CORNER_RIGHT_TOP_ROUNDED] = "╮"
simple_border[constant.CORNER_RIGHT_BOTTOM_ROUNDED] = "╯"
simple_border[constant.CORNER_LEFT_BOTTOM_ROUNDED] = "╰"

return simple_border
