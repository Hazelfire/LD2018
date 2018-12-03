BodyPart = require 'bodyPart'

local P = {}
feet = P

local function update(self, player, dt)
    if player.walking then
        local vx, vy = player.collider:getLinearVelocity()

        local footX, footY = player:getFootPos()
        player.footCollider:setPosition(footX, footY)

        vx = (player.facing == 'right') and self.speed or -self.speed
        player.collider:setLinearVelocity(vx, vy)
    else
        local vx, vy = player.collider:getLinearVelocity()
        player.collider:setLinearVelocity(0, vy)
    end

    if player.jumping and player.grounded then
        player.jumping = false

        local vx, vy = player.collider:getLinearVelocity()
        player.collider:setLinearVelocity(vx, -self.jumpSpeed)
    end

    if not player.grounded then
        player.collider:setFriction(0)
    end
end

function P:new(world, sprite, speed, jumpSpeed)
    bodyPart = BodyPart:new(world, sprite, 'feet')
    bodyPart.speed = speed
    bodyPart.jumpSpeed = jumpSpeed
    bodyPart.update = update

    return bodyPart
end

return feet
