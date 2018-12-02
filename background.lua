local P = {}
background = P

local prototype = {}

function P:new(x, y, w, h, world, sprite)
    local object = {}

    object.x = x
    object.y = y
    object.w = w
    object.h = h
    object.world = world
    object.sprite = sprite

    setmetatable(object, prototype)
    prototype.__index = prototype

    world.manager:addObject(object)

    return object
end

function prototype:render()
    love.graphics.push()
        self.sprite:setWrap('repeat', 'repeat')
        quad = love.graphics.newQuad(0, 0, self.w, self.h, self.sprite:getWidth(), self.sprite:getHeight())
        love.graphics.draw(self.sprite, quad, self.x, self.y)
    love.graphics.pop()
end

return background
