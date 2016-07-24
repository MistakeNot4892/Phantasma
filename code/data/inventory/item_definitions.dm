/data/item/potion
	name = "potion"
	desc = "Restores 20HP."
	can_use_battle =    1
	can_use_overmap =   1
	var/heal_strength = 20

/data/item/potion/do_battle_animation(var/image/target)
	if(!..())
		return
	animate(target, color = PALE_GREEN, time = 10)
	sleep(10)
	animate(target, color = WHITE, time = 10)

/data/item/potion/apply(var/data/minion/target)
	var/mhealth = target.data[MD_MHP]
	target.data[MD_CHP] += heal_strength
	if(target.data[MD_CHP] > mhealth)
		target.data[MD_CHP] = mhealth
	return
