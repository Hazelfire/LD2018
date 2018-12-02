Item = require 'items'

local Enemy = {}

local ENEMY_WIDTH = 18
local ENEMY_HEIGHT = 23

function Enemy:new(world, x, y, parts)
    self = {}

    setmetatable(self, Enemy)
    Enemy.__index = Enemy

    self.collider = world:newRectangleCollider(x, y, ENEMY_WIDTH, ENEMY_HEIGHT)
    self.collider:setCollisionClass('enemy')
    self.collider:setFixedRotation(true)

    self.collider:setFixedRotation(true)
    self.footCollider = world:newRectangleCollider(x + ENEMY_WIDTH / 4, y + ENEMY_HEIGHT, ENEMY_WIDTH / 2, 2)
    self.footCollider:setCollisionClass('foot')
    self.footCollider:setFixedRotation(true)

    self.grounded = false
    self.world = world
    self.height = ENEMY_HEIGHT
    self.width = ENEMY_WIDTH
    
    self.parts = {}

    for key, part in pairs(parts) do
        self.parts[key] = part
    end

    world.manager:addObject(self)

    return self
end

function Enemy:die()
    for _, part in pairs(self.parts) do
        Item:new(self.world, self.collider:getX(), self.collider:getY(), part) end

    self.collider:destroy()
end

function Enemy:getFootPos()
    x = self.collider:getX()
    y = self.collider:getY()
    return x, y + ENEMY_HEIGHT / 2
end

function distance(x1, y1, x2, y2) 
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))    
end

function Enemy:update()
    self.parts.head:update(self, dt)
    self.parts.feet:update(self, dt)
end

function Enemy:render()
    love.graphics.push()
        for _, part in pairs(self.parts) do
            love.graphics.draw(part.sprite, self.collider:getX() - 16, self.collider:getY() - 16)
        end
    love.graphics.pop()
end

return Enemy
