return function(args)
    item = {}
    item.collider = args.world:newRectangleCollider(args.x, args.y, args.width, args.height)
    item.collider:setCollisionClass("item")
    item.collider:setObject(args.object)
    
    item.lifeTime = args.lifeTime or 10
    item.world = world

    item.update = function(self, dt)
        if self.lifeTime > 0 then
            self.lifeTime = self.lifeTime - dt
        end

        if self.lifeTime < 0 then
            self.collider:destroy()
            self.world.manager:removeObject(self)
        end
    end

    item.render = function(self)
        if not self.collider:isDestroyed() then
            love.graphics.push()
                love.graphics.draw(args.sprite, self.collider:getX(), self.collider:getY(), self.collider:getAngle(), 1, 1, args.width / 2 + args.ox, args.height / 2 + args.oy)
            love.graphics.pop()
        end
    end

    args.world.manager:addObject(item)
end
