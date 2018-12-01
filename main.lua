wf = require 'windfield'
Player = require 'player'

function love.load()
    world = wf.newWorld(0, 0, true)
    world:addCollisionClass('ground')
    world:addCollisionClass('player', {ignores= {'player'}})
    world:setGravity(0, 1024)
    
    players = {}

    ground = world:newRectangleCollider(0, 550, 800, 50)
    ground:setType('static')
    ground:setCollisionClass('ground')
end

function love.update(dt)
  world:update(dt)
  for i, player in ipairs(players) do
    player:update()
  end
end

function love.joystickadded(joystick)
    player = Player:new(world, 100, 100, joystick)
    table.insert(players, player)
end

function love.draw()
  for i, player in ipairs(players) do
    player:draw()
  end
end
