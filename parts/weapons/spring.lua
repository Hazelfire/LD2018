local melee = require 'parts/weapons/melee'


return melee{
    name = "Spring",
    width = 7,
    height = 5,
    ox = 12,
    oy = 13,
    cooldown = 0.3,
    reach = 30,
    damage = 2,
    impulse = 200,
    sprite = "spring.png"
}

