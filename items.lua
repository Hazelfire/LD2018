local Item = {}

ITEM_HEIGHT = 15
ITEM_WIDTH = 15

function Item:new(world, x, y)
    self = {}

    self.collider = world:newRectangleCollider(x, y, ITEM_WIDTH, ITEM_HEIGHT)
    self.collider:setCollisionClass("item")

    setmetatable(self, Item)
    Item.__index = Item

    world.manager:addObject(self)
end

function Item:render()
  love.graphics.push()
    love.graphics.rectangle("fill", self.collider:getX() - ITEM_WIDTH / 2, self.collider:getY() - ITEM_HEIGHT / 2, ITEM_WIDTH, ITEM_HEIGHT)
  love.graphics.pop()
end


return Item
