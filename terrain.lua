Wall = require 'wall'
Background = require 'background'

local P = {}
terrain = P

local WALL_WIDTH = 32

local DENSITY = 0.2
local PLATFORM_WIDTH = 5
local PLATFORM_VARIANCE = 2

function P:makeLevel(world, width, height, sprites, scale)
    P:makeBoundary(world, sprites, width, height)
    P:makeBackground(world, sprites, width, height)

    for x=1,width - 1 do
        for y=1,height - 3 do
            if math.random() < DENSITY / PLATFORM_WIDTH then
                platformWidth = math.min(math.floor(math.random() * PLATFORM_VARIANCE * 2 + (PLATFORM_WIDTH - PLATFORM_VARIANCE)), width - x )
                P:makePlatform(x, y, platformWidth, world, sprites['platform.png'])
            end
        end
    end


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

function P:makeBoundary(world, sprites, width, height)

    P:makeWall(0, 0, 1, height, world, sprites['left wall.png'])
    P:makeWall(0, height, 1, 1, world, sprites['floor left corner.png'])
    P:makeWall(1, height, width - 1, 1, world, sprites['floor.png'])
    P:makeWall(width, height, 1, 1, world, sprites['floor right corner.png'])
    P:makeWall(width, 0, 1, height, world, sprites['right wall.png'])
end

function P:makeBackground(world, sprites, width, height)
    love.graphics.setBackgroundColor(135/255, 135/255, 135/255)
    P:makeBackgroundWall(1, 0, 1, height - 1, world, sprites['next to left wall.png'])
    P:makeBackgroundWall(1, height - 1, 1, 1, world, sprites['background floor left corner.png'])
    P:makeBackgroundWall(2, height - 1, width - 2, 1, world, sprites['above floor.png'])
    P:makeBackgroundWall(width - 1, height - 1, 1, 1, world, sprites['right corner.png'])
    P:makeBackgroundWall(width - 1, 0, 1, height - 1, world, sprites['next to right wall.png'])
end

return terrain
