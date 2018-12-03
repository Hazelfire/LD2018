local bodyPart = require 'items/bodyPart'
local P = {}
enemyHead = P

local function distance(x1, y1, x2, y2) 
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2))    
end

local function xor(a, b)
    return not (a == b)
end

local function update(self, player, dt)
    local closest = nil
    local colliders = world:queryCircleArea(player.collider:getX(), player.collider:getY(), 500)
    for _, collider in ipairs(colliders) do
        if collider.collision_class == 'player' then
            if closest then
                x, y = player.collider:getX(), player.collider:getY()
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
        exitGround = player.footCollider:exit('ground')
        enterGround = player.footCollider:enter('ground')
        player.grounded = xor(player.grounded, xor(enterGround, exitGround))

        if closest:getX() > player.collider:getX() then
            player.walking = true
            player.facing = 'right'
        else
            player.walking = true
            player.facing = 'left'
        end

        if player.grounded and player.collider:getY() - closest:getY() > player.height then
            player.jumping = true
        end

    else
        player.walking = false
    end
end

function P:new(world, sprites)
    self = {}

    setmetatable(self, P)
    P.__index = P

    self.sprite = sprites['head.png']
    self.world = world
    return self
end

function P:toPart(x, y)
    return bodyPart{
      world=self.world,
      x=x,
      y=y,
      width= 12,
      height= 6,
      ox = 10,
      oy = 4,
      sprite = self.sprite,
      object = self,
    }
end

return enemyHead
