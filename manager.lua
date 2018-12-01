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

function prototype:addObject(object, tag)
    table.insert(self.objects, {tag=tag, object=object})
end

function prototype:getByTag(tag)
    tagged = {}
    for _,value in pairs(self.objects) do
        if value.tag == tag then
            table.insert(tagged, value.object)
        end
    end

    return tagged
end

function getIndex(table, el)
    for index, value in pairs(table) do
        if value.object == el then
            return index
        end
    end
end

function prototype:removeObject(object)
    table.remove(self.objects, getIndex(self.objects, object))
end

function prototype:updateObjects(dt)
    for key, object in pairs(self.objects) do
        if(object.object.collider and object.object.collider:isDestroyed()) then
            self.objects[key] = nil
            return
        end

        if object.object.update then
            object.object:update(dt)
        end
    end
end

function prototype:renderObjects()
    for _, object in pairs(self.objects) do
        if object.object.render then
            object.object:render()
        end
    end
end

return manager
