local P = {}
wall = P

local prototype = {}

function P:new(x, y, w, h, world)
    local object = {}

    object.x = x
    object.y = y
    object.w = w
    object.h = h

    object.collider = world:newRectangleCollider(x, y, w, h)
    object.collider:setType('static')
    object.collider:setCollisionClass('ground')

    setmetatable(object, prototype)
    prototype.__index = prototype

    world.manager:addObject(object)

    return object
end

function prototype:render()
    love.graphics.push()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    love.graphics.pop()
end

return wall
