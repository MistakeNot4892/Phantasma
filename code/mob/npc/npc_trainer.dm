/mob/trainer/npc
	name = "Eleanor"
	icon_state = "elea"
	starting_minions = list(/data/minion_template/umbermote)
	icon_body = "female"
	icon_clothes = "elea"
	icon_hair = "long_brown"
	icon_eyes = "brown"

/mob/trainer/npc/New()
	..()
	spawn(5)
		following.Move(get_step(src,EAST))