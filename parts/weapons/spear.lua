local melee = require 'parts/weapons/melee'

local SPEAR_HEIGHT = 5
local SPEAR_WIDTH = 24

local SPEAR_IMG_X = 5
local SPEAR_IMG_Y = 14

local COOLDOWN = 0.2
local SPEAR_REACH = 40
local SPEAR_WACK_SPEED = 70

return melee{
    name = "Spear",
    width = SPEAR_WIDTH,
    height = SPEAR_HEIGHT,
    ox = SPEAR_IMG_X,
    oy = SPEAR_IMG_Y,
    cooldown = COOLDOWN,
    reach = SPEAR_REACH,
    damage = 10,
    impulse = SPEAR_WACK_SPEED,
    sprite = "spear.png"
}
