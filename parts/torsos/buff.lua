local bodyPart = require 'items/bodyPart'
local BuffTorso = {}

function BuffTorso:new(world, sprites)
    self = {}

    setmetatable(self, BuffTorso)
    BuffTorso.__index = BuffTorso

    self.sprite = sprites['torso.png']
    self.world = world
    self.type = 'torso'
    self.health = 20
    self.id = "BuffTorso"
    return self
end

function BuffTorso:toPart(x, y)
    return bodyPart{
      world=self.world,
      x=x,
      y=y,
      width= 16,
      height=17,
      ox = 8,
      oy = 6,
      sprite = self.sprite,
      object = self,
    }
end

return BuffTorso

