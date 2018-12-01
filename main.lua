wf = require 'windfield'
Player = require 'player'
Manager = require 'manager'
Terrain = require 'terrain'
Wall = require 'wall'

function love.load()
    love.window.setMode(800, 600)
    
    world = wf.newWorld(0, 0, true)
    world:addCollisionClass('ground')
    world:addCollisionClass('player', {ignores= {'player'}})
    world:setGravity(0, 1024)

    manager = Manager:new()
    world.manager = manager

    Terrain:makeBoundary(world)
end

function love.update(dt)
    world:update(dt)
    manager:updateObjects(dt)
end

function love.joystickadded(joystick)
    Player:new(world, 100, 100, joystick)
end

function love.draw()
    manager:renderObjects()
end
