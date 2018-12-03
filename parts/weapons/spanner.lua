local melee = require 'parts/weapons/melee'

local SPANNER_HEIGHT = 14
local SPANNER_WIDTH = 14

local SPANNER_ARC = math.pi / 2
local COOLDOWN = 0.2
local SPANNER_REACH = 30
local SPANNER_ANGLE_OFFSET = - 3 * math.pi / 4
local SPANNER_WACK_SPEED = 50

return melee{
    name = "Spanner",
    width = SPANNER_WIDTH,
    height = SPANNER_HEIGHT,
    cooldown = COOLDOWN,
    reach = SPANNER_REACH,
    impulse = SPANNER_WACK_SPEED,
    angleOffset = SPANNER_ANGLE_OFFSET,
    arc = SPANNER_ARC,
    damage = 5,
    sprite = "spanner.png"
}

