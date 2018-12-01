wf = require 'windfield'
Manager = require 'manager'
Terrain = require 'terrain'
Wall = require 'wall'

function love.load()
    love.window.setMode(800, 600)
    
    world = wf.newWorld(0, 0, true)
    world:setGravity(0, 512)

    manager = Manager:new()
    world.manager = manager

    Terrain:makeBoundary(world)
end

function love.update(dt)
    world:update(dt)
    manager:updateObjects(dt)
end

function love.draw()
    manager:renderObjects()
end
