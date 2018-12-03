wf = require 'windfield'
SpriteLoader = require 'spriteLoader'
Player = require 'player'
Manager = require 'manager'
Terrain = require 'terrain'
Wall = require 'wall'
Crate = require 'items/crate'
Enemy = require 'enemy'
Workshop = require 'workshop'

local TILE_SIZE = 32

local LEVEL_WIDTH = 25
local LEVEL_HEIGHT = 15

local SPAWN_CAP = 20

function love.load()
    love.window.setMode(800, 608)
    love.window.setFullscreen(true)
    width, height = love.window.getDesktopDimensions()
    scale = math.min(width / (LEVEL_WIDTH + 1) / TILE_SIZE, height / (LEVEL_HEIGHT + 1 )/ TILE_SIZE)

    sprites = SpriteLoader:loadSprites()
    math.randomseed(os.time())

    enemyParts = {
        sprites['torso.png'],
        sprites['treads.png'],
        sprites['gun.png'],
        sprites['head.png'],
    }

    world = wf.newWorld(0, 0, true)
    world:addCollisionClass('ground')
    world:addCollisionClass('player', {ignores= {'player'}})
    world:addCollisionClass('enemy')
    world:addCollisionClass('item', {ignores={'player', 'enemy'}})
    world:addCollisionClass('dead', {ignores={'player', 'enemy'}})
    world:addCollisionClass('foot', {ignores={'player', 'dead','enemy', 'item'}})
    world:addCollisionClass('bullet', {ignores={'player'}})
    world:addCollisionClass('weapon', {ignores={'ground', 'player'}})
    world:setGravity(0, 1024)

    manager = Manager:new()
    world.manager = manager

    Crate:new(world, 150, 100, sprites)

    Terrain:makeLevel(world, LEVEL_WIDTH, LEVEL_HEIGHT ,sprites)

    Workshop:new(world,(LEVEL_WIDTH - 1) * TILE_SIZE, (LEVEL_HEIGHT - 1.5) * TILE_SIZE, sprites)

    time = 0
    enemyCount = 0
end

function love.update(dt)
    world:update(dt)
    manager:updateObjects(dt)
    time = time + dt

    if math.random() < 1 - math.exp(- time / 1000) then
        enemyCount = table.getn(manager:getByTag('enemy'))
        if enemyCount < SPAWN_CAP then
            Enemy:new(world, math.random() * 500 + 50 , 100, enemyParts)
        end
    end
end

function love.joystickadded(joystick)
    Player:new(world, 100, 100, joystick, sprites)
end

function love.keypressed(key)
end

function love.draw()
    local width, height = love.window.getDesktopDimensions()
    local differencex = width - scale * LEVEL_WIDTH * TILE_SIZE
    local differencey = height - scale * LEVEL_HEIGHT * TILE_SIZE
    love.graphics.translate(differencex / 2, differencey / 2)

    love.graphics.scale(scale)
    manager:renderObjects()
end
