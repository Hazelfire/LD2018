Wall = require 'wall'

local P = {}
terrain = P

local WALL_WIDTH = 32

function P:makeBoundary(world, sprite)
    local width, height = love.graphics.getDimensions()
    
    Wall:new(0, 0, WALL_WIDTH, height, world, sprite)
    Wall:new(0, height - WALL_WIDTH, width, WALL_WIDTH, world, sprite)
    Wall:new(width - WALL_WIDTH, 0, WALL_WIDTH, height, world, sprite)
end

return terrain
