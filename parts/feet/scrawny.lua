local bodyPart = require 'items/bodyPart'
local ScrawnyLegs = {}

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
