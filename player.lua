Animator = require 'animator'

Player = {}

PLAYER_HEIGHT = 28
PLAYER_WIDTH = 16
PLAYER_SPEED = 150
JUMP_SPEED = -400

function Player:new(world, x, y, joystick, sprites)
    self = {}
    self.collider = world:newRectangleCollider(x, y, PLAYER_WIDTH, PLAYER_HEIGHT)
    self.collider:setCollisionClass('player')
    self.collider:setFixedRotation(true)
    self.footCollider = world:newRectangleCollider(x + PLAYER_WIDTH / 4, y + PLAYER_HEIGHT, PLAYER_WIDTH / 2, 2)
    self.footCollider:setFixedRotation(true)

    self.joystick = joystick

    self.animator = Animator:new()
    self.animator:setFrames({
        sprites['right walk 1.png'],
        sprites['right walk 2.png'],
    })
    self.animator:setDelay(0.1)
    self.idle = sprites['right walk 1.png']

    self.walking = false

    setmetatable(self, Player)
    Player.__index = Player

    world.manager:addObject(self)

    return self
end

function Player:getFootPos()
    x = self.collider:getX()
    y = self.collider:getY()
    return x, y + PLAYER_HEIGHT / 2
end

function Player:joystickControls()
    local myJoystick = self.joystick
    x, y = self.collider:getLinearVelocity()
    local speed = myJoystick:getGamepadAxis("leftx") * PLAYER_SPEED
    self.collider:setLinearVelocity(speed, y)

    if self.grounded then
        if myJoystick:isGamepadDown("a") then
            x, y = self.collider:getLinearVelocity()
            self.collider:setLinearVelocity(x, JUMP_SPEED)
        end
    end

    self.walking = (speed ~= 0) and true or false
    self.animator:setDelay(0.5 - (math.abs(speed) / 150 * 0.5) + 0.1)
end

function Player:update(dt)
    footX, footY = self:getFootPos()
    self.footCollider:setPosition(footX, footY)

    if self.footCollider:exit('ground') then
        self.grounded = false
        self.collider:setFriction(0)
    end

    if self.footCollider:enter('ground') then
        self.grounded = true
    end

    self:joystickControls()

    self.sprite = (self.walking) and self.animator:getNextFrame(dt) or self.idle
end

function Player:render()
    love.graphics.push()
        love.graphics.draw(self.sprite, self.collider:getX() - 16, self.collider:getY() - 16)
    love.graphics.pop()
end

return Player
