return function(args)
    item = {}
    item.collider = world:newRectangeCollider(args.x, args.y, args.width, args.height)
    item.collider:setCollisionClass("item")
    item.collider:setObject(args.object)
    item.render = function(self)
        if not self.collider:isDestroyed() then
            love.graphics.push()
                love.graphics.draw(args.sprite, self.collider:getX(), self.collider:getY(), self.collider:getAngle(), 1, 1, args.width / 2 + args.ox, args.height / 2 + args.oy)
            love.graphics.pop()
        end
    end
end
