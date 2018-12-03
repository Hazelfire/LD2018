local bodyPart = require 'items/bodyPart'
local Treads = {}

local PLAYER_SPEED = 200
local PLAYER_ACC = 2
local JUMP_SPEED = -200

function Treads:new(world, sprites)
    self = {}

    setmetatable(self, Treads)
    Treads.__index = Treads

    self.sprite = sprites['treads.png']
    self.world = world
    self.type = 'feet'
    self.id="Treads"
    return self
end

function Treads:moveInDirection(player, nx)

    local vx, vy = player.collider:getLinearVelocity()
    local difference = -(vx - nx * PLAYER_SPEED) * PLAYER_ACC
    player.collider:applyForce(difference, 0)
end

function Treads:jump(player, grounded)
    if grounded then
        local x, y = player.collider:getLinearVelocity()
        player.collider:setLinearVelocity(x, JUMP_SPEED)
    end
end


function Treads:toPart(x, y)
    return bodyPart{
      world=self.world,
      x=x,
      y=y,
      width= 22,
      height= 10,
      ox = 5,
      oy = 20,
      sprite = self.sprite,
      object = self,
    }
end

return Treads
