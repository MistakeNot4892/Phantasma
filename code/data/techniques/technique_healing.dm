/data/technique/healing
	name = "Recover"
	target_self = 1
	delay = 25
	max_uses = 5
	var/heal_min = 0.2
	var/heal_max = 0.4

/data/technique/healing/apply_to(var/data/minion/user, var/data/minion/target)

	var/prev = ..()
	if(prev == TECHNIQUE_FAIL)
		return TECHNIQUE_FAIL

	var/mhealth = target.data[MD_MHP]
	target.data[MD_CHP] += round(rand(mhealth*heal_min, mhealth*heal_max))
	if(target.data[MD_CHP] > mhealth)
		target.data[MD_CHP] = mhealth
	return TECHNIQUE_SUCCESS

/data/technique/healing/do_user_front_anim(var/image/target)
	if(!..())
		return
	animate(target, color = PALE_GREEN, time = 10)
	sleep(10)
	animate(target, color = WHITE, time = 10)

/data/technique/healing/do_user_rear_anim(var/image/target)
	if(!..())
		return
	animate(target, color = PALE_GREEN, time = 10)
	sleep(10)
	animate(target, color = WHITE, time = 10)

/data/technique/healing/do_target_front_anim(var/image/target)
	if(!..())
		return
	sleep(10)
	animate(target, color = PALE_GREEN, time = 10)
	sleep(10)
	animate(target, color = WHITE, time = 10)

/data/technique/healing/do_target_rear_anim(var/image/target)
	if(!..())
		return
	sleep(10)
	animate(target, color = PALE_GREEN, time = 10)
	sleep(10)
	animate(target, color = WHITE, time = 10)
