local Bullet = require 'bullet'
local Gun = {}

local GUN_HEIGHT = 14
local GUN_WIDTH = 14

local COOLDOWN = 0.2

GUN_IMG_HEIGHT = 32
GUN_IMG_WIDTH = 32
GUN_IMG_X = 11
GUN_IMG_Y = 14

GUN_HEIGHT = 4
GUN_WIDTH = 11

function Gun:new(world, x, y, sprites)
    self = {}

    self.sprites = sprites

    setmetatable(self, Gun)
    Gun.__index = Spanner

    self.px = x
    self.py = y
    self.angle = 0
    self.collider = world:newRectangleCollider(x, y, SPANNER_WIDTH, SPANNER_HEIGHT)
    self.collider:setCollisionClass('weapon')
    self.collider:setObject(self)
    self.collider:setPreSolve(function(collider1, collider2, contact)
        if self.animationTime <= 0 then
            contact:setEnabled(false)
        end
    end)

    world.manager:addObject(self)

    self.animationTime = 0
    return self
end

function Gun:active()
    return self.animationTime > 0
end

function Gun:setPosition(x, y)
    self.px = x
    self.py = y
end

function Gun:setAngle(angle)
    self.aim = angle
end

function Gun:destroy()
    self.collider:destroy()
end

function Gun:update(dt)
    if self.animationTime > 0 then
        local changeAngle = (COOLDOWN - self.animationTime) / COOLDOWN * SPANNER_ARC
        local distance = math.sin( math.pi / SPANNER_ARC * changeAngle) * SPANNER_REACH
        
        if self.aim > (math.pi / 2) and self.aim < (3 * math.pi / 2) then
            local startAngle = self.aim + SPANNER_ARC / 2
            self.angle = startAngle - changeAngle
        else
            local startAngle = self.aim - SPANNER_ARC / 2
        
            self.angle = startAngle + changeAngle
        end

        self.x = self.px + distance * math.cos(self.angle)
        self.y = self.py + distance * math.sin(self.angle)
        self.animationTime = self.animationTime - dt
    else
        self.angle = self.aim
        self.x = self.px
        self.y = self.py
    end


    if self.collider:enter('enemy') then
        local info = self.collider:getEnterCollisionData('enemy')
        local enemy = info.collider:getObject()
        enemy:die()        
    end

    self.collider:setPosition(self.x, self.y)
    self.collider:setAngle(self.angle)
end

function Gun:use()
    if self.animationTime <= 0 then
        self.animationTime = COOLDOWN
    end
end

function Gun:render()
    love.graphics.push()
        if not (self.x == nil) then
            love.graphics.draw(self.sprites['spanner.png'], self.x, self.y, self.angle - SPANNER_ANGLE_OFFSET, 1, 1, SPANNER_WIDTH / 2, SPANNER_HEIGHT / 2) 
        end
    love.graphics.pop()
end


return Gun
