Animator = require 'animator'
DeadPlayer = require 'deadplayer'
Spanner = require 'weapons/spanner'
Gun = require 'weapons/gun'

Player = {}

PLAYER_HEIGHT = 28
PLAYER_WIDTH = 16
PLAYER_SPEED = 150
JUMP_SPEED = -600
THROW_SPEED = 400

function Player:new(world, x, y, joystick, sprites)
    self = {}
    self.collider = world:newRectangleCollider(x, y, PLAYER_WIDTH, PLAYER_HEIGHT)
    self.collider:setCollisionClass('player')

    self.joystick = joystick
    self.world = world
    self.weapon = Spanner:new(world, x, y, sprites)
    self.weapon:setAngle(0)
    self.grounded = false

    self.collider:setFixedRotation(true)
    self.footCollider = world:newRectangleCollider(x + PLAYER_WIDTH / 4, y + PLAYER_HEIGHT, PLAYER_WIDTH / 2, 2)
    self.footCollider:setCollisionClass('foot')
    self.footCollider:setFixedRotation(true)

    self.animator = Animator:new()
    self.animator:setFrames({
        sprites['right walk 1.png'],
        sprites['right walk 2.png'],
    })
    self.animator:setDelay(0.1)
    self.idle = sprites['right walk 1.png']

    self.lastThrowX = 1
    self.lastThrowY = 0

    self.walking = false

    setmetatable(self, Player)
    Player.__index = Player

    world.manager:addObject(self, 'player')

    return self
end

function Player:getFootPos()
    x = self.collider:getX()
    y = self.collider:getY()
    return x, y + PLAYER_HEIGHT / 2
end

function Player:joystickControls()
    local world = self.world
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

    local rightx = myJoystick:getGamepadAxis("rightx")
    local righty = myJoystick:getGamepadAxis("righty")
    if math.sqrt(math.pow(rightx, 2) + math.pow(righty, 2)) > 0.1 then
        self.weapon:setAngle(math.atan2(righty, rightx))
    end

    if myJoystick:getGamepadAxis("triggerright") > 0.5 then
        self.weapon:use()
    end

    local colliders = world:queryCircleArea(self.collider:getX(), self.collider:getY(), 30, {'item'})
    for _, collider in ipairs(colliders) do
        if myJoystick:isGamepadDown("leftshoulder") then
            if not self.carry then
                self.carry = world:addJoint('RopeJoint', collider, self.collider, collider:getX(), collider:getY(), self.collider:getX(), self.collider:getY(), 30, false)
            end
        end
    end

    if self.carry and self.carry:isDestroyed() then
        self.carry = nil
    end
    if not myJoystick:isGamepadDown("leftshoulder") then
        if self.carry then
            self.carry = self.carry:destroy()
        end
    end

end

function xor(a, b)
    return not (a == b)
end

function Player:die()
    DeadPlayer:new(self.world, self.collider:getX(), self.collider:getY())
    self:delete()
end

function Player:update(dt)
    if self.collider:enter('enemy') then
        self:die()
        self.weapon:destroy()
    else
        if not self.joystick:isConnected() then
            self:die()
        else
            footX, footY = self:getFootPos()
            self.footCollider:setPosition(footX, footY)

            exitGround = self.footCollider:exit('ground')
            enterGround = self.footCollider:enter('ground')
            if enterGround and not exitGround then
                self.grounded = true
            elseif exitGround and not enterGround then
                self.grounded = false
            end

            if not self.grounded then
                self.collider:setFriction(0)
            end

            self:joystickControls()
        end
        self.sprite = (self.walking) and self.animator:getNextFrame(dt) or self.idle
        self.weapon:setPosition(self.collider:getX(), self.collider:getY())
    end

end

function Player:render()
    love.graphics.push()
    if self.sprite and not self.collider:isDestroyed() then
        love.graphics.draw(self.sprite, self.collider:getX() - 16, self.collider:getY() - 16)
    end
    love.graphics.pop()
end

function Player:delete()
    self.world.manager:removeObject(self)
    self.collider:destroy()
    self.footCollider:destroy()
end

return Player
