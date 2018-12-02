BodyPart = require 'bodyPart'

local P = {}
playerHead = P

local function update(self, player, dt)
    if player.collider:enter('enemy') then
        self.die(player)
    else
        if not player.joystick:isConnected() then
            self.die(player)
        else
            footX, footY = self.getFootPos(player)
            player.footCollider:setPosition(footX, footY)

            exitGround = player.footCollider:exit('ground')
            enterGround = player.footCollider:enter('ground')
            player.grounded = self.xor(player.grounded, self.xor(enterGround, exitGround))

            if not player.grounded then
                player.collider:setFriction(0)
            end
            
            self.joystickControls(player)
        end
    end
end

local function xor(a, b)
    return not (a == b)
end


local function die(player)
    DeadPlayer:new(player.world, player.collider:getX(), player.collider:getY())

    player.world.manager:removeObject(player)
    player.collider:destroy()
    player.footCollider:destroy()
end

local function getFootPos(player)
    x = player.collider:getX()
    y = player.collider:getY()
    return x, y + PLAYER_HEIGHT / 2
end

local function joystickControls(player)
    local world = player.world
    local myJoystick = player.joystick
    x, y = player.collider:getLinearVelocity()
    local speed = myJoystick:getGamepadAxis("leftx") * PLAYER_SPEED
    player.collider:setLinearVelocity(speed, y)

    if player.grounded then
        if myJoystick:isGamepadDown("a") then
            x, y = player.collider:getLinearVelocity()
            player.collider:setLinearVelocity(x, JUMP_SPEED)
        end
    end

    player.walking = (speed ~= 0) and true or false
    --player.animator:setDelay(0.5 - (math.abs(speed) / 150 * 0.5) + 0.1)

    local colliders = world:queryCircleArea(player.collider:getX(), player.collider:getY(), 30, {'dead'})
    for _, collider in ipairs(colliders) do
        if myJoystick:isGamepadDown("leftshoulder") then
            if not player.carry then
                player.carry = world:addJoint('RopeJoint', collider, player.collider, collider:getX(), collider:getY(), player.collider:getX(), player.collider:getY(), 30, false)
            end
        end
    end
    if not myJoystick:isGamepadDown("leftshoulder") then
        if player.carry then
            player.carry = player.carry:destroy()
        end
    end

    local colliders = world:queryCircleArea(player.collider:getX(), player.collider:getY(), 30, {'item'})
    for _, collider in ipairs(colliders) do
        if myJoystick:isGamepadDown("x") then
            if not player.weapon then
                player.weapon = collider
            end
        end
    end

    local CARRY_DISTANCE = 40
    local x = myJoystick:getGamepadAxis("rightx")
    local y = myJoystick:getGamepadAxis("righty")

    local d = math.sqrt(math.pow(x,2) + math.pow(y, 2))

    local nx, ny
    if d < 0.1 then
        x = player.lastThrowX
        y = player.lastThrowY
        d = math.sqrt(math.pow(x,2) + math.pow(y, 2))
    end

    local nx = x / d
    local ny = y / d
    player.lastThrowX = x
    player.lastThrowY = y

    if player.weapon then

        item = player.weapon


        if myJoystick:isGamepadDown("rightshoulder") then
            item:setLinearVelocity(nx * THROW_SPEED, ny * THROW_SPEED)
            player.weapon = nil
        end
        item:setPosition(nx * CARRY_DISTANCE + player.collider:getX(), ny *CARRY_DISTANCE + player.collider:getY())

    end
end
    
function P:new(world, sprite, joystick)
    bodyPart = BodyPart:new(world, sprite, 'head')
    bodyPart.update = update
    bodyPart.getFootPos = getFootPos
    bodyPart.die = die
    bodyPart.xor = xor
    bodyPart.joystickControls = joystickControls

    bodyPart.joystick = joystick

    return bodyPart
end

return playerHead
