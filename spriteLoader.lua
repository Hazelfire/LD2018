local P = {}
spriteLoader = P

local SPRITE_DIR = 'sprites'

function P:loadSprites()
    local spriteNames = love.filesystem.getDirectoryItems(SPRITE_DIR)
    local sprites = {}

    for _, spriteName in pairs(spriteNames) do
        local image = love.graphics.newImage(SPRITE_DIR .. '/' .. spriteName)
        sprites[spriteName] = image
    end

    return sprites
end

return spriteLoader
