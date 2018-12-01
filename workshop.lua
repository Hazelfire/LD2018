Player = require 'player'
local Workshop = {}

WORKSHOP_HEIGHT = 40
WORKSHOP_WIDTH = 30

function Workshop:new(world, x, y)
    self = {}

    setmetatable(self, Workshop)
    Workshop.__index = Workshop

    self.x = x
    self.y = y

    world.manager:addObject(self)
    self.world = world

    return self
end

function Workshop:update()
    deadPlayers = self.world:queryRectangleArea(self.x, self.y, WORKSHOP_WIDTH, WORKSHOP_HEIGHT, {'dead'})
    self.restore = deadPlayers[1]
    if self.restore then
        for _, joystick in ipairs(love.joystick.getJoysticks()) do
            if joystick:isGamepadDown("start") then
                Player:new(self.world, self.x, self.y, joystick)
                self.restore = self.restore:destroy()
                break
            end
        end
    end
end

function Workshop:render()
    love.graphics.push()
        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("fill", self.x, self.y, WORKSHOP_WIDTH, WORKSHOP_HEIGHT)
        love.graphics.setColor(1, 1, 1)

        if self.restore then
            love.graphics.print("Press start to spawn", 100, 100)
        end
    love.graphics.pop()
end

return Workshop
