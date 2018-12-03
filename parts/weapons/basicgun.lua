local bodyPart = require 'items/bodyPart'
local BasicGun = {}

function BasicGun:new(world, sprites)
    self = {}

    setmetatable(self, BasicGun)
    BasicGun.__index = BasicGun

    self.sprite = sprites['gun.png']
    self.world = world
    self.type = 'weapon'
    return self
end

function BasicGun:toPart(x, y)
    return bodyPart{
      world=self.world,
      x=x,
      y=y,
      width= 11,
      height= 4,
      ox = 11,
      oy = 14,
      sprite = self.sprite,
      object = self,
    }
end

return BasicGun
