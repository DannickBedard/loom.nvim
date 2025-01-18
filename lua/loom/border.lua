
local constant = require("githelper.borders.constant")

-- TODO :: Handle the case where the width is smaller than the content
local insertTextContent = function(text, currentBorder, win_width)
  text = text:gsub("\t", "    ") -- Remove tab char and remplace by 4 space
  text = " " .. text
  local content = text .. string.rep(' ', win_width - (string.len(text)))

  local contentLine =  currentBorder[constant.SIDE] .. content .. currentBorder[constant.SIDE]
  return contentLine
end

local insertEmptyContent = function(currentBorder, win_width)
  local contentLine =  currentBorder[constant.SIDE] .. string.rep(' ', win_width) .. currentBorder[constant.SIDE]
  return contentLine;
end


local insertTextInsideTopBorder = function(text, currentBorder, win_width)
  local top_border =  currentBorder[constant.CORNER_LEFT_TOP] .. text .. string.rep(currentBorder[constant.SIDE_BOTTOM], win_width - (string.len(text))) .. currentBorder[constant.CORNER_RIGHT_TOP] 
  return top_border
end

local insertEmptyTopBorder = function(currentBorder, win_width)
  local top_border =  currentBorder[constant.CORNER_LEFT_TOP] .. string.rep(currentBorder[constant.SIDE_BOTTOM], win_width) .. currentBorder[constant.CORNER_RIGHT_TOP] 
  return top_border
end

local insertTextInsideBottomBorder = function()

end

local insertEmptyBottomBorder = function(currentBorder, win_width)
  local bottom_border =  currentBorder[constant.CORNER_LEFT_BOTTOM] .. string.rep(currentBorder[constant.SIDE_BOTTOM], win_width) .. currentBorder[constant.CORNER_RIGHT_BOTTOM] 
  return bottom_border
end


return {
  doubleBorder = require("githelper.borders.double"),
  simpleBorder = require("githelper.borders.simple"),
  simpleRoundedBorder = require("githelper.borders.simpleRounded"),
  simpleThickBorder = require("githelper.borders.thick"),
  CORNER_LEFT_TOP = constant.CORNER_LEFT_TOP ,
  CORNER_RIGHT_TOP = constant.CORNER_RIGHT_TOP ,
  CORNER_LEFT_TOP_ROUNDED = constant.CORNER_LEFT_TOP_ROUNDED ,
  CORNER_RIGHT_TOP_ROUNDED = constant.CORNER_RIGHT_TOP_ROUNDED ,
  CORNER_LEFT_BOTTOM = constant.CORNER_LEFT_BOTTOM ,
  CORNER_RIGHT_BOTTOM = constant.CORNER_RIGHT_BOTTOM ,
  CORNER_LEFT_BOTTOM_ROUNDED = constant.CORNER_LEFT_BOTTOM_ROUNDED ,
  CORNER_RIGHT_BOTTOM_ROUNDED = constant.CORNER_RIGHT_BOTTOM_ROUNDED ,
  SIDE = constant.SIDE ,
  SIDE_BOTTOM = constant.SIDE_BOTTOM ,
  SPLIT_TOP = constant.SPLIT_TOP ,
  SPLIT_BOTTOM = constant.SPLIT_BOTTOM ,
  SPLIT_LEFT_SIDE = constant.SPLIT_LEFT_SIDE ,
  SPLIT_RIGHT_SIDE = constant.SPLIT_RIGHT_SIDE ,
  SPLIT_MIDLE = constant.SPLIT_MIDLE,
  fn = {
    topBorder = insertEmptyTopBorder,
    topBorderText = insertTextInsideTopBorder,
    bottomBorder = insertEmptyBottomBorder,
    bottomBorderText = insertTextInsideBottomBorder,
    middleBorder = insertEmptyContent,
    middleBorderText = insertTextContent,
  }

}
