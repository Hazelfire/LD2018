Animator = require 'animator'
DeadPlayer = require 'deadplayer'

Player = {}

PLAYER_HEIGHT = 28
PLAYER_WIDTH = 16
PLAYER_SPEED = 150
JUMP_SPEED = -600
THROW_SPEED = 400

function Player:new(world, x, y, joystick, parts, sprites)
    self = {}
    self.collider = world:newRectangleCollider(x, y, PLAYER_WIDTH, PLAYER_HEIGHT)
    self.collider:setCollisionClass('player')

    self.parts = parts
    self.world = world
    self.joystick = joystick
    self.grounded = false
    
    self.instances = {}

    for partType, part in pairs(parts) do
      if part.class then
        self.instances[partType] = part.class:new(world, sprites)
      end
    end

    self.instances.weapon:setAngle(0)
    self.parts.head.joystick = joystick

    self.collider:setFixedRotation(true)
    self.footCollider = world:newRectangleCollider(x + PLAYER_WIDTH / 4, y + PLAYER_HEIGHT, PLAYER_WIDTH / 2, 2)
    self.footCollider:setCollisionClass('foot')
    self.footCollider:setFixedRotation(true)

    --[[self.animator = Animator:new()
    self.animator:setFrames({
        sprites['right walk 1.png'],
        sprites['right walk 2.png'],
    })
    self.animator:setDelay(0.1)
    self.idle = sprites['right walk 1.png']
    ]]--
    self.headlight = sprites['head-light.png']

    self.lastThrowX = 1
    self.lastThrowY = 0

    self.parts = parts

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
    --self.animator:setDelay(0.5 - (math.abs(speed) / 150 * 0.5) + 0.1)

    local rightx = myJoystick:getGamepadAxis("rightx")
    local righty = myJoystick:getGamepadAxis("righty")
    if math.sqrt(math.pow(rightx, 2) + math.pow(righty, 2)) > 0.1 then
        self.instances.weapon:setAngle(math.atan2(righty, rightx))
    end

    if myJoystick:getGamepadAxis("triggerright") > 0.5 then
        self.instances.weapon:use()
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
    for _, part in pairs(self.parts) do
        part:toPart(self.collider:getX(), self.collider:getY()) 
    end
    self.collider:destroy()
end

function Player:update(dt)
    if self.collider:enter('enemy') then
        self:die()
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
        --self.sprite = (self.walking) and self.animator:getNextFrame(dt) or self.idle
        self.instances.weapon:setPosition(self.collider:getX(), self.collider:getY())
    end
    if not self.collider:isDestroyed() then
        for _, part in pairs(self.instances) do
          if part.update then
            part:update(dt)
          end
        end
    end
end

function Player:render()
    love.graphics.push()
    if not self.collider:isDestroyed() then
        for partType, part in pairs(self.parts) do
            if self.instances[partType] then
              self.instances[partType]:render()
            else
              love.graphics.draw(part.sprite, self.collider:getX() - 16, self.collider:getY() - 16)
            end
        end
    end
    love.graphics.pop()
end

return Player
