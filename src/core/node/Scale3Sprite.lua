local Scale3Sprite = class("Scale3Sprite" , function () --@return scene
    return cc.Node:create()
end)

Scale3Sprite.__index = Scale3Sprite
Scale3Sprite._left = nil
Scale3Sprite._right = nil
Scale3Sprite._center = nil
function Scale3Sprite.ctor()
end


function Scale3Sprite:init(spritePath, centerWidth, contentSize)
    local texture = cc.Director:getInstance():getTextureCache():addImage(spritePath)
    local batchnode = cc.SpriteBatchNode:createWithTexture(texture, 3)
    local textureSize = texture:getContentSize()
    
    
    local _width = (textureSize.width-centerWidth)/2 
    local leftRect = cc.rect(0,0,_width,textureSize.height)
    local centerRect = cc.rect(_width,0,centerWidth,textureSize.height)
    local rightRect = cc.rect(_width+centerWidth,0,_width,textureSize.height)
    
    self._left = cc.Sprite:createWithTexture(texture,leftRect)
    local scaleLeft = contentSize.height/textureSize.height
    self._left:setScale(scaleLeft)
    self._left:setPosition(-scaleLeft*_width-contentSize.width/2,0)
    self:addChild(self._left)
    
    self._center = cc.Sprite:create("res/Platforms/ground_altas.png",cc.rect(0,0,640,64))
    self._center:getTexture():setTexParameters(gl.LINEAR, gl.LINEAR, gl.REPEAT, gl.REPEAT)
    self:addChild(self._center)
    
    self._right = cc.Sprite:createWithTexture(texture,rightRect)
    self._right:setScale(contentSize.height/textureSize.height)
    self._right:setPosition(contentSize.width/2,0)
    self:addChild(self._right)
    
    --self:addChild(batchnode)
end

function Scale3Sprite:initSprite(leftSpritePath, centeSpritePath, rightSpritePath, contentSize)
    local sprite = cc.Sprite:create(centeSpritePath)
    local textureSize = sprite:getTexture():getContentSize()
    local scale = contentSize.height/textureSize.height

    self._left = cc.Sprite:create(leftSpritePath)
    self._left:setScale(scale)
    self._left:setPosition((scale*textureSize.width-contentSize.width)/2,0)
    self:addChild(self._left)

    self._center = cc.Sprite:create(centeSpritePath,cc.rect(0,0, contentSize.width/scale-2*textureSize.width,textureSize.height))
    self._center:setScale(scale)
    self._center:getTexture():setTexParameters(gl.LINEAR, gl.LINEAR, gl.REPEAT, gl.REPEAT)
    self:addChild(self._center)

    self._right = cc.Sprite:create(rightSpritePath)
    self._right:setScale(scale)
    self._right:setPosition((contentSize.width-textureSize.width*scale)/2,0)
    self:addChild(self._right)
end


function Scale3Sprite.create(leftSpritePath, centeSpritePath, rightSpritePath, contentSize)
    local m = Scale3Sprite.new()
    m:initSprite(leftSpritePath, centeSpritePath, rightSpritePath, contentSize)
    return m
end

return Scale3Sprite