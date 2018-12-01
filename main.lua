wf = require 'windfield'
SpriteLoader = require 'spriteLoader'
Player = require 'player'
Manager = require 'manager'
Terrain = require 'terrain'
Wall = require 'wall'

function love.load()
    love.window.setMode(1024, 608)

    sprites = SpriteLoader:loadSprites()
    
    world = wf.newWorld(0, 0, true)
    world:addCollisionClass('ground')
    world:addCollisionClass('player', {ignores= {'player'}})
    world:setGravity(0, 1024)

    manager = Manager:new()
    world.manager = manager

    Terrain:makeBoundary(world, sprites['platform_support.png'])
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

    local width, height = love.graphics.getDimensions()
end
