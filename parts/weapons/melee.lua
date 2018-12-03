local bodyPart = require 'items/bodyPart'

function valueOr0(value)
    if value then
        return value
    else
        return 0
    end
end

return function (args)
    local Weapon = {}

    local WEAPON_HEIGHT = args.height
    local WEAPON_WIDTH = args.width
    local WEAPON_IMG_X = valueOr0(args.ox)
    local WEAPON_IMG_Y = valueOr0(args.oy)

    local WEAPON_ARC = valueOr0(args.arc)

    local COOLDOWN = args.cooldown
    local WEAPON_REACH = args.reach
    local WEAPON_ANGLE_OFFSET = valueOr0(args.angleOffset)
    local WEAPON_WACK_SPEED = args.impulse

    function Weapon:new(world, sprites, side)

        if side == 'enemy' then
            self.attacks = 'player'
        else
            self.attacks = 'enemy'
        end
        self = {}

        self.sprite = sprites[args.sprite]

        setmetatable(self, Weapon)
        self.world = world
        Weapon.__index = Weapon
        self.id = args.name

        self.px = 0
        self.py = 0
        self.angle = 0
        self.damage = args.damage
        self.type = 'weapon'
        self.collider = world:newRectangleCollider(0, 0, WEAPON_WIDTH, WEAPON_HEIGHT)
        self.collider:setCollisionClass('weapon')
        self.collider:setObject(self)
        self.collider:setPreSolve(function(collider1, collider2, contact)
            if self.animationTime <= 0 then
                contact:setEnabled(false)
            end
        end)

        self.animationTime = 0
        return self
    end

    function Weapon:active()
        return self.animationTime > 0
    end

    function Weapon:setPosition(x, y)
        self.px = x
        self.py = y
    end

    function Weapon:setAngle(angle)
        self.aim = angle
    end

    function Weapon:destroy()
        self.collider:destroy()
    end

    function Weapon:update(dt)
        if self.animationTime > 0 then
            local changeAngle, distance
            if not (WEAPON_ARC == 0) then
                changeAngle = (COOLDOWN - self.animationTime) / COOLDOWN * WEAPON_ARC
                distance = math.sin( math.pi / WEAPON_ARC * changeAngle) * WEAPON_REACH
            else
                changeAngle = 0
                local animationTime = (COOLDOWN - self.animationTime) / COOLDOWN
                distance = math.sin( math.pi * animationTime) * WEAPON_REACH
            end

            
            if self.aim > (math.pi / 2) and self.aim < (3 * math.pi / 2) then
                local startAngle = self.aim + WEAPON_ARC / 2
                self.angle = startAngle - changeAngle
            else
                local startAngle = self.aim - WEAPON_ARC / 2
            
                self.angle = startAngle + changeAngle
            end

            self.x = self.px + distance * math.cos(self.angle)
            self.y = self.py + distance * math.sin(self.angle)
            self.animationTime = self.animationTime - dt
        else
            self.angle = self.aim
            self.x = self.px
            self.y = self.py
        end


        if self.collider:enter(self.attacks) then
            local info = self.collider:getEnterCollisionData(self.attacks)
            local enemy = info.collider:getObject()
            if self.animationTime > 0 then
                local nx, ny = info.contact:getNormal()
                info.collider:applyLinearImpulse(-nx * WEAPON_WACK_SPEED, -ny * WEAPON_WACK_SPEED)
                enemy:damage(self.damage)
            end
        end

        self.collider:setPosition(self.x, self.y)
        self.collider:setAngle(self.angle)
    end

    function Weapon:use()
        if self.animationTime <= 0 then
            self.animationTime = COOLDOWN
        end
    end

    function Weapon:render()
        love.graphics.push()
            if not (self.x == nil) then
                love.graphics.draw(self.sprite, self.x, self.y, self.angle - WEAPON_ANGLE_OFFSET, 1, 1, WEAPON_WIDTH / 2 + WEAPON_IMG_X, WEAPON_HEIGHT / 2 + WEAPON_IMG_Y) 
            end
        love.graphics.pop()
    end

    function Weapon:toPart(x, y)
        return bodyPart{
          world=self.world,
          x=x,
          y=y,
          width= WEAPON_WIDTH,
          height= WEAPON_HEIGHT,
          ox = WEAPON_IMG_X,
          oy = WEAPON_IMG_Y,
          sprite = self.sprite,
          object = self,
        }
    end
    return Weapon

end
