local Item = {}

ITEM_HEIGHT = 16
ITEM_WIDTH = 16

function Item:new(world, x, y, sprite, lifeTime)
    self = {}

    self.collider = world:newRectangleCollider(x, y, ITEM_WIDTH, ITEM_HEIGHT)
    self.collider:setCollisionClass("item")

    self.sprite = sprite
    self.lifeTime = lifeTime or -1
    self.world = world

    setmetatable(self, Item)
    Item.__index = Item

    world.manager:addObject(self)
end

function Item:update(dt)
    if self.lifeTime > 0 then
        self.lifeTime = self.lifeTime - dt
    end

    if self.lifeTime < 0 then
        self:die()
    end
end

function Item:die()
    self.collider:destroy()
    self.world.manager:removeObject(self)
end

function Item:render()
    if not self.collider:isDestroyed() then
        love.graphics.push()
            love.graphics.draw(self.sprite, self.collider:getX() - 16, self.collider:getY() - 16) 
        love.graphics.pop()
    end
end


return Item
