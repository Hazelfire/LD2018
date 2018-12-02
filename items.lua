local Item = {}

ITEM_HEIGHT = 16
ITEM_WIDTH = 16

function Item:new(world, x, y, sprite)
    self = {}

    self.collider = world:newRectangleCollider(x, y, ITEM_WIDTH, ITEM_HEIGHT)
    self.collider:setCollisionClass("item")

    self.sprite = sprite

    setmetatable(self, Item)
    Item.__index = Item

    world.manager:addObject(self)
end

function Item:render()
    if not self.collider:isDestroyed() then
        love.graphics.push()
            love.graphics.draw(self.sprite, self.collider:getX() - 16, self.collider:getY() - 16) 
        love.graphics.pop()
    end
end


return Item
