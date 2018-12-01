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
    if collider.collision_class == 'item' then
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
    love.graphics.rectangle("fill", self.collider:getX() - PLAYER_WIDTH / 2, self.collider:getY() - PLAYER_HEIGHT / 2, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.rectangle("line", self.footCollider:getX() - PLAYER_WIDTH / 4, self.footCollider:getY() - 1, PLAYER_WIDTH / 2, 2)
  love.graphics.pop()
end

return Player
