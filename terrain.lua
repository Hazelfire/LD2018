Wall = require 'wall'

local P = {}
terrain = P

local WALL_WIDTH = 32

function P:makeLevel(world, sprites)
    P:makeBoundary(world, sprites)

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

function P:makeBoundary(world, sprites)
    local width, height = love.graphics.getDimensions()

    P:makePlatform(0, 0, 1, 18, world, sprites['left wall.png'])
    P:makePlatform(0, 18, 1, 1, world, sprites['floor left corner.png'])
    P:makePlatform(1, 18, 23, 1, world, sprites['floor.png'])
    P:makePlatform(24, 18, 1, 1, world, sprites['floor right corner.png'])
    P:makePlatform(24, 0, 1, 18, world, sprites['right wall.png'])
end

return terrain
