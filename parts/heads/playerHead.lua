local bodyPart = require 'items/bodyPart'
local P = {}

function P:new(world, sprites)
    self = {}

    setmetatable(self, P)
    P.__index = P

    self.sprite = sprites['player head.png']
    self.world = world
    self.type = 'head'
    self.id = "PlayerHead"
    return self
end

function P:toPart(x, y)
    return bodyPart{
      world=self.world,
      x=x,
      y=y,
      width= 6,
      height= 9,
      ox = 14,
      oy = 3,
      sprite = self.sprite,
      object = self,
    }
end

return P
