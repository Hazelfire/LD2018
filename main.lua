wf = require 'windfield'
SpriteLoader = require 'spriteLoader'
Player = require 'player'
Manager = require 'manager'
Terrain = require 'terrain'
Wall = require 'wall'
Item = require 'items'
Enemy = require 'enemy'
Workshop = require 'workshop'

Feet = require 'parts/feet'
EnemyHead = require 'parts/enemyHead'

function love.load()
    love.window.setMode(800, 608)

    sprites = SpriteLoader:loadSprites()

    enemyParts = {
        head = EnemyHead:new(world, sprites['head.png']),
        torso = {
            sprite = sprites['torso.png'],
        },
        gun = {
            sprite = sprites['gun.png'],
        },
        feet = Feet:new(world, sprites['treads.png'], 100, 400),
    }

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

    Terrain:makeLevel(world, sprites)

    Item:new(world, 150, 100, sprites['crate 1.png'])
    enemy = Enemy:new(world, 300, 100, enemyParts)
    Workshop:new(world, 800 - 30 - 32, 608 - 32 - 40, sprites)
end

function love.update(dt)
    world:update(dt)
    manager:updateObjects(dt)
end

function love.joystickadded(joystick)
    Player:new(world, 100, 100, joystick, sprites)
end

function love.keypressed(key)
    if key == 'q' then
        enemy:die()
    end
end

function love.draw()
    manager:renderObjects()
end
