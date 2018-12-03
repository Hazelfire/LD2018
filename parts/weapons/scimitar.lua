local melee = require 'parts/weapons/melee'

return melee{
    name = "Scimitar",
    width = 16,
    height = 8,
    ox = 10,
    oy = 10,
    cooldown = 0.15,
    reach = 30,
    damage = 3,
    impulse = 35,
    angleOffset = 0,
    arc = math.pi / 2,
    sprite = "scimitar.png"
}

