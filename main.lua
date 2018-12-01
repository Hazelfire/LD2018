wf = require 'windfield'
SpriteLoader = require 'spriteLoader'
Player = require 'player'
Manager = require 'manager'
Terrain = require 'terrain'
Wall = require 'wall'
Item = require 'items'
Enemy = require 'enemy'

function love.load()
    love.window.setMode(800, 608)

    sprites = SpriteLoader:loadSprites()

    world = wf.newWorld(0, 0, true)
    world:addCollisionClass('ground')
    world:addCollisionClass('player', {ignores= {'player'}})
    world:addCollisionClass('enemy')
    world:addCollisionClass('item', {ignores={'player', 'enemy'}})
    world:addCollisionClass('dead', {ignores={'player', 'enemy'}})
    world:addCollisionClass('foot', {ignores={'player', 'dead','enemy', 'item'}})
    world:setGravity(0, 1024)

    manager = Manager:new()
    world.manager = manager

    Item:new(world, 150, 100)
    Enemy:new(world, 300, 100)

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
