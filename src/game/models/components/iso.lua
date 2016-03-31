iso = {}
-------------------
--注意：地图长宽比必须是4：3
iso.tilePixelWidth = 80 			--单位网格像素宽度
iso.tilePixelHeight = 60 			--单位网格像素高度
iso.tileEdge = 50 					--单位网格的边长（即棱形边长）

iso.tileWidth = 80 				--地图水平网格数目
iso.tileHeight = 80				--地图垂直网格数目	

iso.tileWidth_build = 39				--城建水平网格数目
iso.tileHeight_build = 39				--城建垂直网格数目	

iso.mapWidth = iso.tilePixelWidth * iso.tileWidth
iso.mapHeight = iso.tilePixelHeight * iso.tileHeight

iso.scale = display.width/iso.mapWidth
iso.position = cc.p(display.cx, display.cy)
iso.anthorPoint = cc.p(0.5, 0.5)
--------------------------------
-- 45度角iso坐标转换为相对像素坐标
-- @function convertToRelative
-- @param tileX ISO坐标系x坐标
-- @param tileY ISO坐标系Y坐标
-- @return 相对像素坐标
-- end --
function iso.convertToRelative(tileX, tileY)
	local posX = iso.mapWidth/2+iso.tilePixelWidth/2*(tileX-tileY)
	local posY = iso.mapHeight-iso.tilePixelHeight/2*(tileX+tileY)-iso.tilePixelHeight/2
	return posX, posY
end

--------------------------------
-- 像素坐标转换为45度角iso坐标
-- @function convertRelativeToISO
-- @param x 相对X坐标
-- @param y 相对Y坐标
-- @return ISO坐标系坐标
-- end --
function iso.convertRelativeToISO(x, y)
	local newX, newY = iso.convertRelativeToISOPixel(x, y)
    return math.floor(newX/iso.tileEdge),math.floor(newY/iso.tileEdge)
end

function iso.convertRelativeToISOPixel(x, y)
    return 5/2*(iso.mapHeight/3-iso.mapWidth/8+x/4-y/3),5/2*(iso.mapHeight/3+iso.mapWidth/8-x/4-y/3)
end

function iso.ISOPixelconvertToRelative(x, y)
	return iso.convertToRelative(x/iso.tileEdge, y/iso.tileEdge)
end
--------------------------------
-- 依据ISO坐标系的scale、anthorPoint、position将45度角iso坐标转换为世界像素坐标
-- @function convertToGlobal
-- @param x ISO坐标系x坐标
-- @param y ISO坐标系Y坐标
-- @return 世界坐标
-- end --
function iso.convertToGlobal(tileX, tileY)
	local relativeX = iso.mapWidth/2+iso.tilePixelWidth/2*(tileX-tileY)
	local relativeY = iso.mapHeight-iso.tilePixelHeight/2*(tileX+tileY)-iso.tilePixelHeight/2
	local x = (relativeX - iso.anthorPoint.x*iso.tilePixelWidth*iso.tileWidth) * iso.scale + iso.position.x
	local y = (relativeY - iso.anthorPoint.y*iso.tilePixelHeight*iso.tileHeight) * iso.scale + iso.position.y
	return x, y
end

--------------------------------
-- 依据ISO坐标系的scale、anthorPoint、position将世界像素坐标转换为45度角iso坐标
-- @function convertToGlobal
-- @param x 世界X坐标
-- @param y 世界Y坐标
-- @return ISO坐标系坐标
-- end --
function iso.convertGlobalToISO(x, y)
    x = (x-iso.position.x)/iso.scale+iso.anthorPoint.x*iso.tilePixelWidth*iso.tileWidth
    y = (y-iso.position.y)/iso.scale+iso.anthorPoint.y*iso.tilePixelHeight*iso.tileHeight
    return math.floor(5/2*(iso.mapHeight/3-iso.mapWidth/8+x/4-y/3)/iso.tileEdge),math.floor(5/2*(iso.mapHeight/3+iso.mapWidth/8-x/4-y/3)/iso.tileEdge)
end
