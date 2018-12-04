local bodyPart = require 'items/bodyPart'
local Bomb = {}

local BOMB_WIDTH = 4
local BOMB_HEIGHT = 6

local BOMB_IMG_X = 14
local BOMB_IMG_Y = 11

local BOMB_RADIUS = 50
local BOMB_IMPULSE = 200
local BOMB_DAMAGE = 30

function Bomb:new(world, sprites, side)
    self = {}

    self.sprite = sprites['bomb.png']

    setmetatable(self, Bomb)
    Bomb.__index = Bomb
    self.id = "Bomb"

    self.world = world
    if side == 'enemy' then
        self.attacks = 'player'
    else
        self.attacks = 'enemy'
    end
    self.x = 0
    self.y = 0
    self.angle = 0
    self.type = 'weapon'
    self.collider = world:newRectangleCollider(0, 0, BOMB_WIDTH, BOMB_HEIGHT)
    self.collider:setCollisionClass('weapon')
    self.collider:setObject(self)

    self.animationTime = 0
    return self
end

function Bomb:active()
    return self.animationTime > 0
end

function Bomb:setPosition(x, y)
    self.x = x
    self.y = y
end

function Bomb:setAngle(angle)
    self.aim = angle
end

function Bomb:destroy()
    self.collider:destroy()
end

function Bomb:update(dt)

end

function Bomb:use(player)
    local others = self.world:queryCircleArea(self.x, self.y, BOMB_RADIUS)
    for _, other in ipairs(others) do
        if other.collision_class == self.attacks then
            other:getObject():damage(BOMB_DAMAGE)
        end
    end
    local others = self.world:queryCircleArea(self.x, self.y, BOMB_RADIUS)
    for _, other in ipairs(others) do
        local px, py = player.collider:getPosition()
        local ox, oy = other:getPosition()
        local d = math.sqrt(math.pow(px - ox, 2) + math.pow(py - oy, 2))
        local nx = (ox - px) / d
        local ny = (oy - py) / d
        other:applyLinearImpulse(nx * BOMB_IMPULSE, ny * BOMB_IMPULSE)
    end
    player:damage(BOMB_DAMAGE)
end

function Bomb:render()
    love.graphics.push()
        if not (self.x == nil) then
            love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, BOMB_WIDTH / 2 + BOMB_IMG_X, BOMB_HEIGHT / 2 + BOMB_IMG_Y) 
        end
    love.graphics.pop()
end

function Bomb:toPart(x, y)
    return bodyPart{
      world=world,
      x=x,
      y=y,
      width= BOMB_WIDTH,
      height= BOMB_HEIGHT,
      ox = BOMB_IMG_X,
      oy = BOMB_IMG_Y,
      sprite = self.sprite,
      object = self,
    }
end


return Bomb
