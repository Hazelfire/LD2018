Wall = require 'wall'

local P = {}
terrain = P

local WALL_WIDTH = 32

function P:makeLevel(world, sprites)
    P:makeBoundary(world, sprites['platform_support.png'])

    P:makePlatform(5, 16, 3, 1, world, sprites['platform.png'])
    P:makePlatform(10, 15, 5, 1, world, sprites['platform.png'])
end

function P:makePlatform(tx, ty, tw, th, world, sprite)
    local x = tx * sprite:getWidth()
    local y = ty * sprite:getHeight()
    local w = tw * sprite:getWidth()
    local h = th * sprite:getHeight()

    Wall:new(x, y, w, h, world, sprite)
end

function P:makeBoundary(world, sprite)
    local width, height = love.graphics.getDimensions()
    
    Wall:new(0, 0, WALL_WIDTH, height, world, sprite)
    Wall:new(0, height - WALL_WIDTH, width, WALL_WIDTH, world, sprite)
    Wall:new(width - WALL_WIDTH, 0, WALL_WIDTH, height, world, sprite)
end

return terrain
