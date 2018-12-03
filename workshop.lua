Player = require 'player'
local Workshop = {}

WORKSHOP_HEIGHT = 40
WORKSHOP_WIDTH = 30

function Workshop:new(world, x, y, sprites)
    self = {}

    setmetatable(self, Workshop)
    Workshop.__index = Workshop

    self.x = x
    self.y = y
    self.canSpawn = false
    self.hasHead = false
    self.hasTorso = false
    self.hasWeapon = false
    self.hasFeet = false
    self.sprites = sprites
    self.savedParts = {}

    world.manager:addObject(self)
    self.world = world

    return self
end

function Workshop:isAssigned(joystick)
    players = self.world.manager:getByTag('player')
    for _, player in ipairs(players) do
        if player.joystick:getID() == joystick:getID() then
            return true
        end
    end
    return false
end

function Workshop:update()
    deadPlayers = self.world:queryRectangleArea(self.x, self.y, WORKSHOP_WIDTH, WORKSHOP_HEIGHT, {'dead'})
    self.body = deadPlayers[1]
    if self.body then
        for _, joystick in ipairs(love.joystick.getJoysticks()) do
            if joystick:isGamepadDown("start") then
                if not self:isAssigned(joystick) then
                    Player:new(self.world, self.x, self.y, joystick, self.sprites)
                    self.body = self.body:destroy()
                    break
                end
            end
        end
    end

    items = self.world:queryRectangleArea(self.x, self.y, WORKSHOP_WIDTH, WORKSHOP_HEIGHT, {'item'})
    for _, part in ipairs(items) do
        table.insert(self.savedParts, part:getObject())
        self.canSpawn = self:determineCanSpawn()        
        part:destroy()
    end
end

function Workshop:determineCanSpawn()
  for _, part in ipairs(self.savedParts) do
    if part.type == 'head' then
      self.hasHead = true
    end
    if part.type == 'torso' then
      self.hasTorso = true
    end
    if part.type == 'weapon' then
      self.hasWeapon = true
    end
    if part.type == 'feet' then
      self.hasFeet = true
    end
  end

  return self.hasHead and self.hasTorso and self.hasWeapon and self.hasFeet
end

function Workshop:render()
    love.graphics.push()
        love.graphics.draw(self.sprites["workshop-base.png"], self.x, self.y)

        if self.hasHead then
            love.graphics.draw(self.sprites["workshop-head.png"], self.x, self.y)
        end

        if self.hasTorso then
            love.graphics.draw(self.sprites["workshop-torso.png"], self.x, self.y)
        end
        if self.hasWeapon then
            love.graphics.draw(self.sprites["workshop-weapon.png"], self.x, self.y)
        end
        if self.hasFeet then
            love.graphics.draw(self.sprites["workshop-feet.png"], self.x, self.y)
        end

        if self.canSpawn then
            love.graphics.draw(self.sprites["workshop-ready.png"], self.x, self.y)
            love.graphics.print("Press start to spawn", 100, 100)
        end
    love.graphics.pop()
end

return Workshop
