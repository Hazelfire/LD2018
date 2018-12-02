Wall = require 'wall'
Background = require 'background'

local P = {}
terrain = P

local WALL_WIDTH = 32

function P:makeLevel(world, sprites)
    P:makeBoundary(world, sprites)
    P:makeBackground(world, sprites)

    P:makePlatform(5, 16, 3, world, sprites['platform.png'])
    P:makePlatform(10, 15, 5, world, sprites['platform.png'])
end

function P:makeWall(tx, ty, tw, th, world, sprite)
    local x = tx * sprite:getWidth()
    local y = ty * sprite:getHeight()
    local w = tw * sprite:getWidth()
    local h = th * sprite:getHeight()

    Wall:new(x, y, w, h, world, sprite)
end

function P:makePlatform(tx, ty, tw, world, sprite)
    local x = tx * sprite:getWidth()
    local y = ty * sprite:getHeight()
    local w = tw * sprite:getWidth()

    Wall:new(x, y, w, 5, world, sprite)
end

function P:makeBackgroundWall(tx, ty, tw, th, world, sprite)
    local x = tx * sprite:getWidth()
    local y = ty * sprite:getHeight()
    local w = tw * sprite:getWidth()
    local h = th * sprite:getHeight()

    Background:new(x, y, w, h, world, sprite)
end

function P:makeBoundary(world, sprites)
    local width, height = love.graphics.getDimensions()

    P:makeWall(0, 0, 1, 18, world, sprites['left wall.png'])
    P:makeWall(0, 18, 1, 1, world, sprites['floor left corner.png'])
    P:makeWall(1, 18, 23, 1, world, sprites['floor.png'])
    P:makeWall(24, 18, 1, 1, world, sprites['floor right corner.png'])
    P:makeWall(24, 0, 1, 18, world, sprites['right wall.png'])
end

function P:makeBackground(world, sprites)
    love.graphics.setBackgroundColor(135/255, 135/255, 135/255)
    P:makeBackgroundWall(1, 0, 1, 17, world, sprites['next to left wall.png'])
    P:makeBackgroundWall(1, 17, 1, 1, world, sprites['background floor left corner.png'])
    P:makeBackgroundWall(2, 17, 21, 1, world, sprites['above floor.png'])
    P:makeBackgroundWall(23, 17, 1, 1, world, sprites['right corner.png'])
    P:makeBackgroundWall(23, 0, 1, 17, world, sprites['next to right wall.png'])
end

return terrain
