local P = {}
animator = P

local prototype = {}

function P:new()
    local object = {
        frames = {},
        delay = 0,
        index = 1,
        timer = 0,
    }

    setmetatable(object, prototype)
    prototype.__index = prototype

    return object
end

function prototype:setFrames(frames)
    for i, frame in ipairs(frames) do
        self.frames[i] = frame
    end
    self.index = 1
end

function prototype:setDelay(delay)
    self.delay = delay
end

function prototype:getNextFrame(dt)
    self.timer = self.timer + dt

    if self.timer >= self.delay then
        self.timer = 0
        self.index = (self.index < table.getn(self.frames)) and self.index + 1 or 1
    end

    return self.frames[self.index]
end

return animator
