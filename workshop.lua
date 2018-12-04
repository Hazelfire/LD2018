Player = require 'player'
local Workshop = {}

WORKSHOP_HEIGHT = 48
WORKSHOP_WIDTH = 32
local workshop = {}

function Workshop:new(world, x, y, sprites)
    self = {}

    setmetatable(self, Workshop)
    Workshop.__index = Workshop

    workshop = self
    self.x = x
    self.y = y
    self.canSpawn = false
    self.hasHead = false
    self.hasTorso = false
    self.hasWeapon = false
    self.hasFeet = false
    self.sprites = sprites
    self.savedParts = {}
    self.options = {
        torso = {},
        weapon = {},
        feet = {},
    }

    world.manager:addObject(self)
    self.world = world
    self.choices = {}
    self.selected = {}

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

function Workshop:getHeadWithJoystick(joystick)
    for _, part in ipairs(self.savedParts) do
        if part.type == 'head' then
            if part.joystick:getID() == joystick:getID() then
                return part
            end
        end
    end

    return nil
end
function Workshop:getChosenBody(joystick)
    local chosen = self.choices[joystick:getID()]
    local options = self.options
    return {
        head = self:getHeadWithJoystick(joystick),
        torso = options['torso'][chosen[1] + 1],
        weapon = options['weapon'][chosen[2] + 1],
        feet = options['feet'][chosen[3] + 1],
    }
end

function Workshop:update()
    if self.canSpawn then
        for _, joystick in ipairs(love.joystick.getJoysticks()) do
            if joystick:isGamepadDown("start") then
                if self:hasHeadFor(joystick) then
                    local parts = self:getChosenBody(joystick)
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
        self.canSpawn = self:determineCanSpawn()        
        if not (part:getObject().type == 'head') then
            self:addOption(part:getObject())
        end
        part:destroy()
    end

    if self.canSpawn then
        local heads = self:getHeads()
        for i, head in ipairs(heads) do
            if not self.choices[head.joystick:getID()] then
                self.choices[head.joystick:getID()] = {
                    0,
                    0,
                    0
                }
                self.selected[head.joystick:getID()] = 0
            end
        end
    end
end

function Workshop:addOption(newPart)
    local partType = newPart.type
    for _, part in pairs(self.options[partType]) do
        if part.id == newPart.id then
            return
        end
    end

    table.insert(self.options[partType], newPart)
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

function love.gamepadpressed( joystick, button )
    local self = workshop
    if self.canSpawn then
        if self.choices[joystick:getID()] then
            local choices = self.choices[joystick:getID()]
            local selected = self.selected[joystick:getID()]
            local selectedString = ""

            if selected == 0 then selectedString = "torso" end
            if selected == 1 then selectedString = "weapon" end
            if selected == 2 then selectedString = "feet" end
            if button == 'dpup' then
                self.selected[joystick:getID()] = (selected - 1) % 3
            end

            if button == 'dpdown' then
                self.selected[joystick:getID()] = (selected + 1) % 3
            end

            if button == 'dpleft' then
                choices[selected + 1] = (choices[selected + 1] - 1) % #self.options[selectedString]
            end

            if button == 'dpright' then
                choices[selected + 1] = (choices[selected + 1] + 1) % #self.options[selectedString]
            end
        end
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
        if part.type == 'head' then
            table.insert(heads, part)
        end
    end
    return heads
end

function Workshop:drawSelection(x, y, head)
    local joystick = head.joystick
    local id = joystick:getID()
    local selected = self.selected[id]
    local choices = self.choices[id]
    local options = self.options
    love.graphics.push()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle('fill', x, y + (32 * ( 1 + selected)), 32, 32)
        love.graphics.draw(head.sprite, x, y)
        
        local torsoOptions = options['torso']

        local choiceIndex = choices[1] + 1
        local torsoChoice = torsoOptions[choiceIndex]
        love.graphics.draw(torsoOptions[choices[1] + 1].sprite, x, y + 32)
        love.graphics.draw(options['weapon'][choices[2] + 1].sprite, x, y + 32 * 2)
        love.graphics.draw(options['feet'][choices[3] + 1].sprite, x, y + 32 * 3)
    love.graphics.pop()
end

function Workshop:render()
    love.graphics.push()
    love.graphics.draw(self.sprites["workshop-base.png"], self.x, self.y)

    if self.canSpawn then
        local heads = self:getHeads()
        for i, head in ipairs(heads) do
            self:drawSelection(self.x - i * 32, self.y - 128, head)
        end
    end

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
