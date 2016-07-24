/data/technique
	var/name = "Filler Tech"
	var/max_uses = 0
	var/delay = 25
	var/accuracy = 0
	var/target_self
	var/is_hostile
	var/priority

/data/technique/proc/apply_to(var/data/minion/user, var/data/minion/target)
	if(user.tech_uses[name] <= 0)
		return TECHNIQUE_FAIL
	user.tech_uses[name]--
	return (prob(accuracy) ? TECHNIQUE_SUCCESS : TECHNIQUE_MISSED)

/data/technique/proc/do_user_front_anim(var/image/target)
	set waitfor=0
	set background=1
	if(!istype(target))
		return
	return 1

/data/technique/proc/do_user_rear_anim(var/image/target)
	set waitfor=0
	set background=1
	if(!istype(target))
		return
	return 1

/data/technique/proc/do_target_front_anim(var/image/target)
	set waitfor=0
	set background=1
	if(!istype(target))
		return
	return 1

/data/technique/proc/do_target_rear_anim(var/image/target)
	set waitfor=0
	set background=1
	if(!istype(target))
		return
	return 1

/data/technique/proc/do_battlefield_animation(var/data/battle_data/target)
	return
