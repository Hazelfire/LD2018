wf = require 'windfield'
SpriteLoader = require 'spriteLoader'
Player = require 'player'
Manager = require 'manager'
Terrain = require 'terrain'
Wall = require 'wall'
Crate = require 'items/crate'
Enemy = require 'enemy'
Workshop = require 'workshop'

Spanner = require 'parts/weapons/spanner'
Bomb = require 'parts/weapons/bomb'
Scimitar = require 'parts/weapons/scimitar'
Spring = require 'parts/weapons/spring'
Quarterstaff = require 'parts/weapons/quarterstaff'
Spear = require 'parts/weapons/spear'
BasicGun = require 'parts/weapons/basicgun'

ScrawnyTorso = require 'parts/torsos/scrawny'
BuffTorso = require 'parts/torsos/buff'

EnemyHead = require 'parts/heads/enemyHead'
PlayerHead = require 'parts/heads/playerHead'

Treads = require 'parts/feet/treads'
ScrawnyLegs = require 'parts/feet/scrawny'

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


    world = wf.newWorld(0, 0, true)
    world:addCollisionClass('ground')
    world:addCollisionClass('player', {ignores= {'player'}})
    world:addCollisionClass('enemy')
    world:addCollisionClass('item', {ignores={'player', 'enemy'}})
    world:addCollisionClass('dead', {ignores={'player', 'enemy'}})
    world:addCollisionClass('foot', {ignores={'player', 'dead','enemy', 'item'}})
    world:addCollisionClass('bullet', {ignores={'player', 'enemy'}})
    world:addCollisionClass('weapon', {ignores={'ground', 'player', 'enemy'}})
    world:setGravity(0, 1024)

    --world:setQueryDebugDrawing(true)

    manager = Manager:new()
    world.manager = manager


    Terrain:makeLevel(world, LEVEL_WIDTH, LEVEL_HEIGHT ,sprites)

    Workshop:new(world,(LEVEL_WIDTH - 1) * TILE_SIZE, (LEVEL_HEIGHT - 1.5) * TILE_SIZE, sprites)
    Crate:new(world, 150, 100, sprites, Bomb)
    Crate:new(world, 150, 100, sprites, Spear)
    Crate:new(world, 150, 100, sprites, Quarterstaff)
    Crate:new(world, 150, 100, sprites, Spring)
    Crate:new(world, 150, 100, sprites, Scimitar)

    time = 0
    enemyCount = 0
end

function love.update(dt)
    world:update(dt)
    manager:updateObjects(dt)
    time = time + dt

    if math.random() < (1 - math.exp(- time / 50000)) * math.sin(time * 2 * math.pi / 60) then
        enemyCount = table.getn(manager:getByTag('enemy'))
        if enemyCount < SPAWN_CAP then
            local enemyWeapons = {
                BasicGun,
                Bomb,
                Spear,
                Spring,
                Quarterstaff,
                Scimitar,
                Spanner,
            }
            local enemyParts = {
                head = EnemyHead:new(world, sprites),
                torso = BuffTorso:new(world, sprites),
                weapon = enemyWeapons[math.random(#enemyWeapons)]:new(world, sprites),
                feet = Treads:new(world, sprites),
            }
            Enemy:new(world, math.random() * 500 + 50 , 100, enemyParts)
        end
    end

    for _, joystick in pairs(love.joystick.getJoysticks()) do
        if joystick:isGamepadDown('back') then
            love.event.quit()
        end
    end
end

function love.joystickadded(joystick)
    local thisPlayerParts = {
        head = PlayerHead:new(world, sprites, joystick),
        torso = ScrawnyTorso:new(world, sprites),
        weapon = Spanner:new(world, sprites),
        feet = ScrawnyLegs:new(world,sprites),  
    }

    Player:new(world, 100, 100, joystick, thisPlayerParts, sprites)
end

function love.draw()
    local width, height = love.window.getDesktopDimensions()
    local differencex = width - scale * LEVEL_WIDTH * TILE_SIZE
    local differencey = height - scale * LEVEL_HEIGHT * TILE_SIZE
    love.graphics.translate(differencex / 2, differencey / 2)

    love.graphics.scale(scale)
    manager:renderObjects()
end
