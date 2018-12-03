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
    self.choices = {}

    return self
end

function Workshop:hasHeadFor(joystick)
    for _, part in ipairs(self.savedParts) do
        if part.type == 'head' then
          if part.joystick:getID() == joystick:getID() then
            return true
          end
        end
    end

    return false
end

function getIndex(table, el)
    for index, value in pairs(table) do
        if value.object == el then
            return index
        end
    end
end

function Workshop:removeParts(parts)
    for _, part in pairs(parts) do 
        table.remove(self.savedParts, getIndex(self.savedParts, part))
    end
end

function Workshop:update()
    if self.canSpawn then
        for _, joystick in ipairs(love.joystick.getJoysticks()) do
            if joystick:isGamepadDown("start") then
                if self:hasHeadFor(joystick) then
                    local parts = self:defaultBody()
                    self:removeParts(parts)
                    self.canSpawn = self:determineCanSpawn()        
                    Player:new(self.world, self.x, self.y, joystick, parts ,self.sprites )
                    break
                end
            end
        end
    end

    items = self.world:queryRectangleArea(self.x, self.y, WORKSHOP_WIDTH, WORKSHOP_HEIGHT, {'item'})
    for _, part in ipairs(items) do
        table.insert(self.savedParts, part:getObject())
        part:destroy()
        self.canSpawn = self:determineCanSpawn()        
    end

    --[[local heads = self:getHeads()
    for i, head in ipairs(heads) do
      self.choices[heads.joystick:getID()] = self:updateChoices(joystick)
    end]]--
end

function Workshop:findWithType(bodyType)
  for _, part in ipairs(self.savedParts) do
      if part.type == bodyType then
        return part
      end
  end

  return nil
end

function Workshop:defaultBody()
  return {
    head = self:findWithType('head'),
    torso = self:findWithType('torso'),
    weapon = self:findWithType('weapon'),
    feet = self:findWithType('feet'),
  }
end

function Workshop:updateChoices(joystick)
  local currentChoices = self.choices[joystick:getID()]
  
  if not currentChoices then
  end
end

function Workshop:determineCanSpawn()
  self.hasHead = false
  self.hasTorso = false
  self.hasWeapon = false
  self.hasFeet = false
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

function Workshop:getHeads()
  local heads = {}
  for _, part in ipairs(self.savedParts) do
    table.insert(heads, part)
  end
  return heads
end

function Workshop:render()
    love.graphics.push()
        love.graphics.draw(self.sprites["workshop-base.png"], self.x, self.y)

        if self.hasHead then
            love.graphics.draw(self.sprites["workshop-head.png"], self.x, self.y)

            local heads = self:getHeads()
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
