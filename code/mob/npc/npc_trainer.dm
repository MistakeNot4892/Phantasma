/mob/trainer/npc
	name = "Eleanor"
	icon_state = "elea"
	starting_minions = list(/data/minion_template/umbermote)
	icon_strings = list(
		TRAINER_ICON_BODY = "female",
		TRAINER_ICON_CLOTHES = "elea",
		TRAINER_ICON_HAIR = "long_brown",
		TRAINER_ICON_EYES = "brown"
		)

/mob/trainer/npc/New()
	..()
	spawn(5)
		following.Move(get_step(src,EAST))