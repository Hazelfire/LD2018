wf = require 'windfield'
SpriteLoader = require 'spriteLoader'
Manager = require 'manager'
Terrain = require 'terrain'
Wall = require 'wall'

function love.load()
    love.window.setMode(800, 608)
    
    sprites = SpriteLoader:loadSprites()

    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 512)
    world:addCollisionClass('ground')

    manager = Manager:new()
    world.manager = manager

    Terrain:makeBoundary(world, sprites['platform_support.png'])
end

function love.update(dt)
    world:update(dt)
    manager:updateObjects(dt)
end

function love.draw()
    manager:renderObjects()
end
