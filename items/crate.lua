Bomb = require 'parts/weapons/bomb'

local Crate = {}

CRATE_HEIGHT = 32
CRATE_WIDTH = 32

function Crate:new(world, x, y, sprites, part)
    self = {}

    self.collider = world:newRectangleCollider(x, y, CRATE_WIDTH, CRATE_HEIGHT)
    self.collider:setCollisionClass("item")
    self.collider:setObject(self)
    self.part = part

    self.sprites = sprites

    setmetatable(self, Crate)
    Crate.__index = Crate
    self.world = world

    world.manager:addObject(self)
end

function Crate:update()
    if self.collider:enter('weapon') then
        if self.collider:getEnterCollisionData('weapon').collider:getObject():active() then
            self:use()
        end
    end

    if self.collider:enter('bullet') then
        if self.collider:getEnterCollisionData('bullet').collider:getObject():active() then
            self:use()
        end
    end
end

function Crate:use()
    
    self.part:new(self.world, self.sprites, 'player'):toPart(self.collider:getX(), self.collider:getY())

    self.collider:destroy()

    return true
end

function Crate:render()
    love.graphics.push()
        if not self.collider:isDestroyed() then
            love.graphics.draw(self.sprites['crate 1.png'], self.collider:getX(), self.collider:getY(), self.collider:getAngle(), 1,1, CRATE_WIDTH / 2, CRATE_HEIGHT / 2) 
        end
    love.graphics.pop()
end


return Crate
