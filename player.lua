Animator = require 'animator'
DeadPlayer = require 'deadplayer'

Player = {}

PLAYER_HEIGHT = 28
PLAYER_WIDTH = 16
PLAYER_SPEED = 150
JUMP_SPEED = -600
THROW_SPEED = 400

function Player:new(world, x, y, parts)
    self = {}
    self.collider = world:newRectangleCollider(x, y, PLAYER_WIDTH, PLAYER_HEIGHT)
    self.collider:setCollisionClass('player')

    self.world = world
    self.grounded = false

    self.collider:setFixedRotation(true)
    self.footCollider = world:newRectangleCollider(x + PLAYER_WIDTH / 4, y + PLAYER_HEIGHT, PLAYER_WIDTH / 2, 2)
    self.footCollider:setCollisionClass('foot')
    self.footCollider:setFixedRotation(true)

    self.lastThrowX = 1
    self.lastThrowY = 0

    self.parts = parts

    setmetatable(self, Player)
    Player.__index = Player

    world.manager:addObject(self, 'player')

    return self
end

function Player:update(dt)
    self.parts.head:update(self, dt)
end

function Player:render()
    love.graphics.push()
        if not self.collider:isDestroyed() then
            for _, part in pairs(self.parts) do
                love.graphics.draw(part.sprite, self.collider:getX() - 16, self.collider:getY() - 16)
            end
        end
    love.graphics.pop()
end

return Player
