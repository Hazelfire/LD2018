local P = {}
manager = P

local prototype = {}

function P:new()
    local object = {
        objects = {}
    }

    setmetatable(object, prototype)
    prototype.__index = prototype

    return object
end

function prototype:addObject(object)
    table.insert(self.objects, object)
end

function prototype:updateObjects(dt)
    for key, object in pairs(self.objects) do
        if(object.collider and object.collider:isDestroyed()) then
            self.objects[key] = nil
            return
        end

        if object.update then
            object:update(dt)
        end
    end
end

function prototype:renderObjects()
    for _, object in pairs(self.objects) do
        if object.render then
            object:render()
        end
    end
end
