local bodyPart = require 'items/bodyPart'
local ScrawnyTorso = {}

function ScrawnyTorso:new(world, sprites)
    self = {}

    setmetatable(self, ScrawnyTorso)
    ScrawnyTorso.__index = ScrawnyTorso

    self.sprite = sprites['scrawny body 1.png']
    self.world = world
    self.type = 'torso'
    self.id = "ScrawnyTorso"
    return self
end

function ScrawnyTorso:toPart(x, y)
    return bodyPart{
      world=self.world,
      x=x,
      y=y,
      width= 14,
      height=10,
      ox = 9,
      oy = 12,
      sprite = self.sprite,
      object = self,
    }
end

return ScrawnyTorso
