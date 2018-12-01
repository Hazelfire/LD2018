local Enemy = {}

local ENEMY_WIDTH = 20
local ENEMY_HEIGHT = 20
local ENEMY_SPEED = 120
local JUMP_SPEED = -600

function Enemy:new(world, x, y)
    self = {}

    setmetatable(self, Enemy)
    Enemy.__index = Enemy

    self.collider = world:newRectangleCollider(x, y, ENEMY_WIDTH, ENEMY_HEIGHT)
    self.collider:setCollisionClass('enemy')
    self.collider:setFixedRotation(true)

    self.collider:setFixedRotation(true)
    self.footCollider = world:newRectangleCollider(x + ENEMY_WIDTH / 4, y + ENEMY_HEIGHT, ENEMY_WIDTH / 2, 2)
    self.footCollider:setCollisionClass('foot')
    self.footCollider:setFixedRotation(true)

    self.grounded = false

    world.manager:addObject(self)

    return self
end

function Enemy:getFootPos()
    x = self.collider:getX()
    y = self.collider:getY()
    return x, y + ENEMY_HEIGHT / 2
end

function distance(x1, y1, x2, y2) 
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))    
end

function Enemy:update()
    local closest = nil
    local colliders = world:queryCircleArea(self.collider:getX(), self.collider:getY(), 500)
    for _, collider in ipairs(colliders) do
        if collider.collision_class == 'player' then
            if closest then
                x, y = self.collider:getX(), self.collider:getY()
                cx, cy = collider:getX(), collider:getY()
                clx, cly = closest:getX(), closest:getY()

                if distance(x,y,cx,cy) < distance(x,y,clx,cly) then
                    closest = collider
                end
            else
                closest = collider
            end
        end
    end 

    if closest then
        exitGround = self.footCollider:exit('ground')
        enterGround = self.footCollider:enter('ground')
        self.grounded = xor(self.grounded, xor(enterGround, exitGround))

        vx, vy = self.collider:getLinearVelocity()

        footX, footY = self:getFootPos()
        self.footCollider:setPosition(footX, footY)

        if closest:getX() > self.collider:getX() then
            self.collider:setLinearVelocity(ENEMY_SPEED, vy)
        else
            self.collider:setLinearVelocity(-ENEMY_SPEED, vy)
        end

        if self.grounded and self.collider:getY() - closest:getY() > ENEMY_HEIGHT then
            x, y = self.collider:getLinearVelocity()
            self.collider:setLinearVelocity(x, JUMP_SPEED)
        end

        if not self.grounded then
            self.collider:setFriction(0)
        end
    end
end

function Enemy:render()
    love.graphics.push()
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("fill", self.collider:getX() - ENEMY_WIDTH / 2, self.collider:getY() - PLAYER_HEIGHT / 2, PLAYER_WIDTH, PLAYER_HEIGHT)
        love.graphics.setColor(1, 1, 1)
    love.graphics.pop()
end

return Enemy