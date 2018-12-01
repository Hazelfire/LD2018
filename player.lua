Player = {}

PLAYER_HEIGHT = 28
PLAYER_WIDTH = 16
PLAYER_SPEED = 150
JUMP_SPEED = -400

function Player:new(world, x, y, joystick)
    self = {}
    self.collider = world:newRectangleCollider(x, y, PLAYER_WIDTH, PLAYER_HEIGHT)
    self.collider:setCollisionClass('player')
    self.collider:setFixedRotation(true)
    self.footCollider = world:newRectangleCollider(x + PLAYER_WIDTH / 4, y + PLAYER_HEIGHT, PLAYER_WIDTH / 2, 2)
    self.footCollider:setFixedRotation(true)

    self.joystick = joystick

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
end

function Player:update()
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
end

function Player:render()
    love.graphics.push()
        love.graphics.draw(sprites['right walk 2.png'], self.collider:getX() - 16, self.collider:getY() - 16)
    love.graphics.pop()

    --[[
    love.graphics.push()
        love.graphics.rectangle("fill", self.collider:getX() - PLAYER_WIDTH / 2, self.collider:getY() - PLAYER_HEIGHT / 2, PLAYER_WIDTH, PLAYER_HEIGHT)
        love.graphics.rectangle("line", self.footCollider:getX() - PLAYER_WIDTH / 4, self.footCollider:getY() - 1, PLAYER_WIDTH / 2, 2)
    love.graphics.pop()
    --]]
end

return Player
