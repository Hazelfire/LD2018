local melee = require 'parts/weapons/melee'


return melee{
    name = "Quarterstaff",
    width = 30,
    height = 3,
    ox = 1,
    oy = 15,
    cooldown = 0.2,
    reach = 40,
    arc = math.pi,
    impulse = 50,
    damage = 5,
    sprite = "quarterstaff.png"
}

