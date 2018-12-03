local bodyPart = require 'items/bodyPart'
local Treads = {}

function Treads:new(world, sprites)
    self = {}

    setmetatable(self, Treads)
    Treads.__index = Treads

    self.sprite = sprites['treads.png']
    self.world = world
    self.type = 'feet'
    return self
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
