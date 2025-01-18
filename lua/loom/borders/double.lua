local constant = require("githelper.borders.constant")

local double_border = { }
double_border[constant.CORNER_LEFT_TOP] = "╔"
double_border[constant.CORNER_RIGHT_TOP] = "╗"
double_border[constant.CORNER_LEFT_BOTTOM] = "╚"
double_border[constant.CORNER_RIGHT_BOTTOM] = "╝"
double_border[constant.SIDE] = "║"
double_border[constant.SIDE_BOTTOM] = "═"
double_border[constant.SPLIT_TOP] = "═"
double_border[constant.SPLIT_BOTTOM] = "═"
double_border[constant.SPLIT_MIDLE] = "╬"
double_border[constant.SPLIT_LEFT_SIDE] = "╠"
double_border[constant.SPLIT_RIGHT_SIDE] = "╣"

return double_border
