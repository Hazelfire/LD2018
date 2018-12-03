local bodyPart = require 'items/bodyPart'
local bullet = require 'bullet'
local BasicGun = {}

local GUN_WIDTH = 11
local GUN_HEIGHT = 4

local GUN_IMG_X = 11
local GUN_IMG_Y = 14

local COOLDOWN = 0.5

function BasicGun:new(world, sprites)
    self = {}

    setmetatable(self, BasicGun)
    BasicGun.__index = BasicGun

    self.sprite = sprites['gun.png']
    self.bulletSprite = sprites['bullet.png']
    self.x = 0
    self.y = 0
    self.id = "BasicGun"
    self.angle = 0
    self.world = world
    self.cooldown = 0
    self.type = 'weapon'
    return self
end

function BasicGun:setPosition(x, y)
    self.x = x
    self.y = y
end

function BasicGun:setAngle(angle)
    self.angle = angle
end

function BasicGun:render()
    love.graphics.push()
    if not (self.x == nil) then
        love.graphics.draw(self.sprite, self.x, self.y, self.angle, 1, 1, GUN_WIDTH / 2 + GUN_IMG_X, GUN_HEIGHT / 2 + GUN_IMG_Y) 
    end
    love.graphics.pop()
end

function BasicGun:update(dt)
    if self.cooldown > 0 then
        self.cooldown = self.cooldown - dt
    end
end

function BasicGun:toPart(x, y)
    return bodyPart{
        world= world,
        x=x,
        y=y,
        width= GUN_WIDTH,
        height= GUN_HEIGHT,
        ox = GUN_IMG_X,
        oy = GUN_IMG_Y,
        sprite = self.sprite,
        object = self,
    }

end

function BasicGun:use()
    if self.cooldown <= 0 then
        bullet:new(self.world, self.x, self.y, self.angle, self.bulletSprite, 5)
        self.cooldown = COOLDOWN
    end
end

return BasicGun
