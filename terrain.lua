Wall = require 'wall'

local P = {}
terrain = P

local WALL_WIDTH = 30

function P:makeBoundary(world)
    local width, height = love.graphics.getDimensions()
    
    Wall:new(0, 0, WALL_WIDTH, height, world)
    Wall:new(0, height - WALL_WIDTH, width, WALL_WIDTH, world)
    Wall:new(width - WALL_WIDTH, 0, WALL_WIDTH, height, world)
end

return terrain
