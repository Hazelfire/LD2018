local P = {}
feet = P

local prototype = {}

function P:new(world, sprite, bodyType)
    local object = {
        bodyType = bodyType,
        world = world,
        sprite = sprite,
    }

    setmetatable(object, prototype)
    prototype.__index = prototype

    return object
end

function prototype:setUpdate(update)
    self.update = update
end

function prototype:createItem(x, y)
    item = Item:new(self.world, x, y, self.sprite)
    item.collider:setObject(self)
    item.collider:setWidth(self.sprite:getWidth())
    item.collider:setHeight(self.sprite:getHeight())
end

return feet
