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
    love.graphics.push()
        love.graphics.draw(self.sprite, self.collider:getX() - 8, self.collider:getY() - 8, 0, 0.5, 0.5) 
    love.graphics.pop()
end


return Item
