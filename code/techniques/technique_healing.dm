/technique/healing
	name = "Recover"
	target_self = 1
	delay = 25
	max_uses = 5
	var/heal_min = 0.2
	var/heal_max = 0.4

/technique/healing/apply_to(var/minion/user, var/minion/target)

	. = ..()
	if(. & TECHNIQUE_FAIL)
		return .

	var/mhealth = target.data[MD_MHP]
	target.data[MD_CHP] += round(rand(mhealth*heal_min, mhealth*heal_max))
	if(target.data[MD_CHP] > mhealth)
		target.data[MD_CHP] = mhealth
	return TECHNIQUE_SUCCESS

/technique/healing/do_user_front_anim(var/image/target)
	if(!..())
		return
	animate(target, color = "#00FF00", time = 10)
	sleep(10)
	animate(target, color = "#FFFFFF", time = 10)

/technique/healing/do_user_rear_anim(var/image/target)
	if(!..())
		return
	animate(target, color = "#00FF00", time = 10)
	sleep(10)
	animate(target, color = "#FFFFFF", time = 10)
