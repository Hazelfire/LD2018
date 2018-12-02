local Bullet = {}

BULLET_IMG_HEIGHT = 32
BULLET_IMG_WIDTH = 32
BULLET_IMG_X = 12
BULLET_IMG_Y = 15

BULLET_HEIGHT = 2
BULLET_WIDTH = 5

BULLET_SPEED = 1000

function Bullet:new(world, x, y, angle, sprites)
    self = {}

    setmetatable(self, Bullet)
    Bullet.__index = Bullet

    self.collider = world:newRectangleCollider(x, y, BULLET_WIDTH, BULLET_HEIGHT)
    self.collider:setAngle(angle)
    self.collider:setLinearVelocity(math.cos(angle) * BULLET_SPEED, math.sin(angle) * BULLET_SPEED)
    self.collider:setCollisionClass('bullet')

    self.sprites = sprites

    world.manager:addObject(self)

    return self
end

function Bullet:render()
    love.graphics.push()
        love.graphics.draw(self.sprites['gun.png'], self.collider:getX(), self.collider:getY(), self.collider:getAngle(), 1, 1, BULLET_WIDTH / 2 + BULLET_IMG_X, BULLET_HEIGHT / 2 + BULLET_IMG_Y) 
    love.graphics.pop()
end

return Bullet
