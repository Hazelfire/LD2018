local Bullet = {}

BULLET_IMG_HEIGHT = 32
BULLET_IMG_WIDTH = 32
BULLET_IMG_X = 12
BULLET_IMG_Y = 15

BULLET_HEIGHT = 2
BULLET_WIDTH = 5

BULLET_SPEED = 1000
LETHAL_SPEED = 500
BULLET_DAMAGE = 5

function Bullet:new(world, x, y, angle, sprite, lifeTime, attacks)
    self = {}

    setmetatable(self, Bullet)
    Bullet.__index = Bullet

    self.collider = world:newRectangleCollider(x, y, BULLET_WIDTH, BULLET_HEIGHT)
    self.collider:setAngle(angle)
    self.collider:setLinearVelocity(math.cos(angle) * BULLET_SPEED, math.sin(angle) * BULLET_SPEED)
    self.collider:setCollisionClass('bullet')

    self.sprite = sprite
    self.lifeTime = lifeTime
    self.world = world
    self.attacks = attacks

    world.manager:addObject(self)

    return self
end

function Bullet:die()
    self.collider:destroy()
    self.world.manager:removeObject(self)
end

function Bullet:getSpeed()
    local vx, vy = self.collider:getLinearVelocity()
    return math.sqrt(vx ^ 2 + vy ^ 2)
end

function Bullet:update(dt)
    self.lifeTime = self.lifeTime - dt

    if self.lifeTime < 0 then
        self:die()
    end

    if self.collider:enter(self.attacks) then
        local speed = self:getSpeed()
        if speed >= LETHAL_SPEED then
            local info = self.collider:getEnterCollisionData(self.attacks)
            local enemy = info.collider:getObject()
            enemy:damage(5)
        end
    end
end

function Bullet:render()
    love.graphics.push()
        if self.collider then
            love.graphics.draw(self.sprite, self.collider:getX(), self.collider:getY(), self.collider:getAngle(), 1, 1, BULLET_WIDTH / 2 + BULLET_IMG_X, BULLET_HEIGHT / 2 + BULLET_IMG_Y) 
        end
    love.graphics.pop()
end

return Bullet
