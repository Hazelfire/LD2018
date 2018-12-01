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

   setmetatable(self, Player)
   Player.__index = Player

   return self
end

function Player:getFootPos()
  x = self.collider:getX()
  y = self.collider:getY()
  return x + PLAYER_WIDTH / 4, y + PLAYER_HEIGHT
end

function Player:joystickControls()
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
end

function Player:update()
  footX, footY = self:getFootPos()
  self.footCollider:setPosition(footX, footY)

  if self.footCollider:exit('ground') then
    self.grounded = false
  end
  
  if self.footCollider:enter('ground') then
    self.grounded = true
  end

  self:joystickControls()
end

function Player:draw()
  love.graphics.rectangle("fill", self.collider:getX(), self.collider:getY(), PLAYER_WIDTH, PLAYER_HEIGHT)
  love.graphics.rectangle("line", self.footCollider:getX(), self.footCollider:getY(), PLAYER_WIDTH / 2, 2)
end

return Player
