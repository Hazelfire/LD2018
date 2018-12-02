Gun = require 'items/gun'

local Crate = {}

CRATE_HEIGHT = 32
CRATE_WIDTH = 32

function Crate:new(world, x, y, sprites)
    self = {}

    self.collider = world:newRectangleCollider(x, y, CRATE_WIDTH, CRATE_HEIGHT)
    self.collider:setCollisionClass("item")
    self.collider:setObject(self)

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
end

function Crate:use()
    
    Gun:new(self.world, self.collider:getX(), self.collider:getY(), self.sprites)

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
