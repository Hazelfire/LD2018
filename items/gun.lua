Bullet = require 'bullet'
local Gun = {}

GUN_IMG_HEIGHT = 32
GUN_IMG_WIDTH = 32
GUN_IMG_X = 11
GUN_IMG_Y = 14

GUN_HEIGHT = 4
GUN_WIDTH = 11

function Gun:new(world, x, y, sprites)
    self = {}

    self.collider = world:newRectangleCollider(x, y, GUN_WIDTH, GUN_HEIGHT)
    self.collider:setCollisionClass("item")
    self.collider:setObject(self)

    self.sprites = sprites
    self.world = world

    setmetatable(self, Gun)
    Gun.__index = Gun

    world.manager:addObject(self)
end

function Gun:use()
    Bullet:new(self.world,self.collider:getX(), self.collider:getY(), self.collider:getAngle(), sprites)
    return false
end

function Gun:render()
    love.graphics.push()
        love.graphics.draw(self.sprites['gun.png'], self.collider:getX(), self.collider:getY(), self.collider:getAngle(), 1, 1, GUN_WIDTH / 2 + GUN_IMG_X, GUN_HEIGHT / 2 + GUN_IMG_Y) 
    love.graphics.pop()
end


return Gun
