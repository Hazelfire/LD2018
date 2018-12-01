wf = require 'windfield'
SpriteLoader = require 'spriteLoader'
Player = require 'player'
Manager = require 'manager'
Terrain = require 'terrain'
Wall = require 'wall'
Item = require 'items'

function love.load()
    love.window.setMode(800, 608)
    
    sprites = SpriteLoader:loadSprites()

    world = wf.newWorld(0, 0, true)
    world:addCollisionClass('ground')
    world:addCollisionClass('player', {ignores= {'player'}})
    world:addCollisionClass('item', {ignores={'player'}})
    world:setGravity(0, 1024)

    manager = Manager:new()
    world.manager = manager

    Item:new(world, 150, 100)

    Terrain:makeLevel(world, sprites)
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
