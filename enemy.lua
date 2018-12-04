Item = require 'items'

local Enemy = {}

local ENEMY_WIDTH = 18
local ENEMY_HEIGHT = 23

function Enemy:new(world, x, y, parts, sprites)
    self = {}

    setmetatable(self, Enemy)
    Enemy.__index = Enemy
    self.sprites = sprites

    self.collider = world:newRectangleCollider(x, y, ENEMY_WIDTH, ENEMY_HEIGHT)
    self.collider:setCollisionClass('enemy')
    self.collider:setFixedRotation(true)

    self.collider:setFixedRotation(true)
    self.collider:setObject(self)
    self.footCollider = world:newRectangleCollider(x + ENEMY_WIDTH / 4, y + ENEMY_HEIGHT, ENEMY_WIDTH / 2, 2)
    self.footCollider:setCollisionClass('foot')
    self.footCollider:setFixedRotation(true)

    self.grounded = false
    self.world = world
    self.height = ENEMY_HEIGHT
    self.width = ENEMY_WIDTH

    self.health = parts.torso.health
    
    self.parts = parts 

    self.parts.weapon.attacks = 'player'

    world.manager:addObject(self, 'enemy')

    return self
end

function Enemy:damage(amount)
    self.health = self.health - amount
    if self.health < 0 then
        self:die()
    end
end

function Enemy:die()
    for _, part in pairs(self.parts) do
        if not (part.type == 'head') then
          part:toPart(self.collider:getX(), self.collider:getY())
        end
    end

    self.collider:destroy()
end

function Enemy:getFootPos()
    x = self.collider:getX()
    y = self.collider:getY()
    return x, y + ENEMY_HEIGHT / 2
end

function distance(x1, y1, x2, y2) 
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))    
end

function Enemy:update(dt)
    if not self.collider:isDestroyed() then
        self.parts.weapon:setPosition(self.collider:getX(), self.collider:getY())

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

            if self.parts.weapon.setAngle then
                local x, y = self.collider:getPosition()
                local playerx, playery = closest:getPosition()

                --Aim and fire weapon
                local dx = playerx - x
                local dy = playery - y
                self.parts.weapon:setAngle(math.atan2(dy, dx))

                rayHits = self.world:queryLine(x, y, playerx, playery, {'All', except={'item', 'weapon'}})
                local closestHit
                for _, hit in pairs(rayHits) do
                    if not closestHit then
                        closestHit = hit
                    elseif distance(x, y, hit:getX(), hit:getY()) < distance (x, y, closestHit:getX(), closestHit:getY()) then
                        closestHit = hit
                    end
                end

                if closestHit and closestHit.collision_class == 'player' then
                    self.parts.weapon:use()
                end
            end

            exitGround = self.footCollider:exit('ground')
            enterGround = self.footCollider:enter('ground')
            if enterGround and not exitGround then
                self.grounded = true
            elseif exitGround and not enterGround then
                self.grounded = false
            end

            vx, vy = self.collider:getLinearVelocity()

            footX, footY = self:getFootPos()
            self.footCollider:setPosition(footX, footY)

            if closest:getX() > self.collider:getX() then
                self.parts.feet:moveInDirection(self, 1)
            else
                self.parts.feet:moveInDirection(self, -1)
            end

            if self.collider:getY() - closest:getY() > ENEMY_HEIGHT then
                self.parts.feet:jump(self, self.grounded)
                x, y = self.collider:getLinearVelocity()
            end

            if not self.grounded then
                self.collider:setFriction(0)
            end
        else
            x, y = self.collider:getLinearVelocity()
            self.collider:setLinearVelocity(0, y)
        end

        for _, part in pairs(self.parts) do
          if part.update then
            part:update(dt)
          end
        end
    end
end

function Enemy:render()
    if not self.collider:isDestroyed() then
        love.graphics.push()
            for partType, part in pairs(self.parts) do
                if self.parts[partType].render then
                  self.parts[partType]:render()
                else
                  love.graphics.draw(part.sprite, self.collider:getX() - 16, self.collider:getY() - 16)
                end
            end
        love.graphics.pop()
    end
end

return Enemy
