/data/item/potion
	name = "potion"
	desc = "A herbal potion that restores 20 hit points when used."
	can_use_battle =    1
	can_use_overmap =   1
	var/heal_strength = 20

/data/item/potion/do_battle_animation(var/image/target)
	if(!..())
		return
	animate(target, color = "#00FF00", time = 10)
	sleep(10)
	animate(target, color = "#FFFFFF", time = 10)

/data/item/potion/apply(var/minion/target)
	var/mhealth = target.data[MD_MHP]
	target.data[MD_CHP] += heal_strength
	if(target.data[MD_CHP] > mhealth)
		target.data[MD_CHP] = mhealth
	return
