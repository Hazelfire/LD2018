local bodyPart = require 'items/bodyPart'
local Spear = {}

local SPEAR_HEIGHT = 5
local SPEAR_WIDTH = 24

local SPEAR_IMG_X = 5
local SPEAR_IMG_Y = 14

local COOLDOWN = 0.2
local SPEAR_REACH = 40
local SPEAR_WACK_SPEED = 70

function Spear:new(world, sprites, side)
    self = {}

    self.sprite = sprites['spear.png']

    setmetatable(self, Spear)
    Spear.__index = Spear
    self.id = "Spear"

    if side == 'enemy' then
        self.attacks = 'player'
    else
        self.attacks = 'enemy'
    end

    self.px = 0
    self.py = 0
    self.angle = 0
    self.damage = 8
    self.type = 'weapon'
    self.collider = world:newRectangleCollider(0, 0, SPEAR_WIDTH, SPEAR_HEIGHT)
    self.collider:setCollisionClass('weapon')
    self.collider:setObject(self)
    self.collider:setPreSolve(function(collider1, collider2, contact)
        if self.animationTime <= 0 then
            contact:setEnabled(false)
        end
    end)

    self.animationTime = 0
    return self
end

function Spear:active()
    return self.animationTime > 0
end

function Spear:setPosition(x, y)
    self.px = x
    self.py = y
end

function Spear:setAngle(angle)
    self.angle = angle
end

function Spear:destroy()
    self.collider:destroy()
end

function Spear:update(dt)
    if self.animationTime > 0 then
        local percentageOfAnimation = (COOLDOWN - self.animationTime) / COOLDOWN
        local distance = math.sin( math.pi * percentageOfAnimation) * SPEAR_REACH
        
        self.x = self.px + distance * math.cos(self.angle)
        self.y = self.py + distance * math.sin(self.angle)
        self.animationTime = self.animationTime - dt
    else
        self.x = self.px
        self.y = self.py
    end


    if self.collider:enter(self.attacks) then
        local info = self.collider:getEnterCollisionData(self.attacks)
        local enemy = info.collider:getObject()
        if self.animationTime > 0 then
            local nx, ny = info.contact:getNormal()
            info.collider:applyLinearImpulse(-nx * SPEAR_WACK_SPEED, -ny * SPEAR_WACK_SPEED)
            enemy:damage(self.damage)
        end
    end

    self.collider:setPosition(self.x, self.y)
    self.collider:setAngle(self.angle)
end

function Spear:use()
    if self.animationTime <= 0 then
        self.animationTime = COOLDOWN
    end
end

function Spear:render()
    love.graphics.push()
        if not (self.x == nil) then
            love.graphics.draw(self.sprite, self.x, self.y, self.angle, 1, 1, SPEAR_WIDTH / 2, SPEAR_HEIGHT / 2 + SPEAR_IMG_Y) 
        end
    love.graphics.pop()
end

function Spear:toPart(x, y)
    return bodyPart{
      world=world,
      x=x,
      y=y,
      width= SPEAR_WIDTH,
      height= SPEAR_HEIGHT,
      ox = SPEAR_IMG_X,
      oy = SPEAR_IMG_Y,
      sprite = self.sprite,
      object = self,
    }
end


return Spear
