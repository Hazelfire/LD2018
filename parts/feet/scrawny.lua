local bodyPart = require 'items/bodyPart'
local ScrawnyLegs = {}

local PLAYER_SPEED = 150
local PLAYER_ACC = 10
local JUMP_SPEED = -400

function ScrawnyLegs:new(world, sprites)
    self = {}

    setmetatable(self, ScrawnyLegs)
    ScrawnyLegs.__index = ScrawnyLegs

    self.sprite = sprites['scrawny legs 1.png']
    self.world = world
    self.type = 'feet'
    self.id = "ScrawnyLegs"
    return self
end

function ScrawnyLegs:moveInDirection(player, nx)

    local vx, vy = player.collider:getLinearVelocity()
    local difference = -(vx - nx * PLAYER_SPEED) * PLAYER_ACC
    player.collider:applyForce(difference, 0)
end

function ScrawnyLegs:jump(player, grounded)
    if true then
        local x, y = player.collider:getLinearVelocity()
        player.collider:setLinearVelocity(x, JUMP_SPEED)
    end
end

function ScrawnyLegs:toPart(x, y)
    return bodyPart{
        world=self.world,
        x=x,
        y=y,
        width= 13,
        height= 11,
        ox = 12,
        oy = 22,
        sprite = self.sprite,
        object = self,
    }
end

return ScrawnyLegs
