DeadPlayer = require 'deadplayer'
Player = {}

PLAYER_HEIGHT = 20
PLAYER_WIDTH = 20
PLAYER_SPEED = 150
JUMP_SPEED = -400

function Player:new(world, x, y, joystick)
    self = {}
    self.collider = world:newRectangleCollider(x, y, PLAYER_WIDTH, PLAYER_HEIGHT)
    self.collider:setCollisionClass('player')
    self.footCollider = world:newRectangleCollider(x + PLAYER_WIDTH / 4, y + PLAYER_HEIGHT, PLAYER_WIDTH / 2, 2)

    self.joystick = joystick
    self.world = world
    self.grounded = false

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

    local colliders = world:queryCircleArea(self.collider:getX(), self.collider:getY(), 30)
    for _, collider in ipairs(colliders) do
        if collider.collision_class == 'dead' then
            if myJoystick:isGamepadDown("x") then
                if not self.carry then
                    self.carry = world:addJoint('RopeJoint', collider, self.collider, collider:getX(), collider:getY(), self.collider:getX(), self.collider:getY(), 30, false)
                end
            end
        end
    end
    if not myJoystick:isGamepadDown("x") then
        if self.carry then
            self.carry = self.carry:destroy()
        end
    end
end

function xor(a, b)
    return not (a == b)
end



function Player:update()
    if not self.joystick:isConnected() then
        DeadPlayer:new(self.world, self.collider:getX(), self.collider:getY())
        self:delete()
    else
        footX, footY = self:getFootPos()
        self.footCollider:setPosition(footX, footY)


        exitGround = self.footCollider:exit('ground')
        enterGround = self.footCollider:enter('ground')
        exitDead = self.footCollider:exit('dead')
        enterDead = self.footCollider:enter('dead')

        if not (exitGround or enterGround or exitDead or enterDead) then
            self.grounded = self.grounded
        else
            if self.grounded then
                if not (exitGround or enterGround or exitDead or enterDead) then
                    self.grounded = self.grounded
                else
                    print("Something happened")
                    exitedGround = xor(exitGround, enterGround)
                    exitedDead = xor(exitDead, enterDead)
                    if exitedGround or exitedDead then
                        self.grounded = false
                    end
                end
            else
                if enterGround or enterDead then
                    self.grounded = true
                end
            end
        end

        if not self.grounded then
            self.collider:setFriction(0)
        end
        
        self:joystickControls()
    end
end

function Player:render()
    love.graphics.push()
        love.graphics.rectangle("fill", self.collider:getX() - PLAYER_WIDTH / 2, self.collider:getY() - PLAYER_HEIGHT / 2, PLAYER_WIDTH, PLAYER_HEIGHT)
        love.graphics.rectangle("line", self.footCollider:getX() - PLAYER_WIDTH / 4, self.footCollider:getY() - 1, PLAYER_WIDTH / 2, 2)
    love.graphics.pop()
end

function Player:delete()
    self.world.manager:removeObject(self)
    self.collider:destroy()
    self.footCollider:destroy()
end

return Player
