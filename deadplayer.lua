local DeadPlayer = {}

PLAYER_HEIGHT = 20
PLAYER_WIDTH = 20

function DeadPlayer:new(world, x, y)
    self = {}

    setmetatable(self, DeadPlayer)
    DeadPlayer.__index = DeadPlayer

    self.collider = world:newRectangleCollider(x, y, PLAYER_WIDTH, PLAYER_HEIGHT)
    self.collider:setCollisionClass('dead')

    world.manager:addObject(self)

    return self
end

function DeadPlayer:render()
    love.graphics.push()
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", self.collider:getX() - PLAYER_WIDTH / 2, self.collider:getY() - PLAYER_HEIGHT / 2, PLAYER_WIDTH, PLAYER_HEIGHT)
        love.graphics.setColor(1, 1, 1)
    love.graphics.pop()
end

return DeadPlayer
