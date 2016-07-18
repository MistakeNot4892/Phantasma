var/list/techniques_by_path = list()
/proc/get_tech_by_path(var/techpath)
	if(!techniques_by_path[techpath])
		techniques_by_path[techpath] = new techpath()
	return techniques_by_path[techpath]

/technique
	var/name = "Strike"
	var/max_uses = 5
	var/delay = 25
	var/target_self

/technique/proc/apply_to(var/minion/user, var/minion/target)
	if(user.tech_uses[name] <= 0)
		return 0
	user.tech_uses[name]--
	return 1

/technique/proc/do_user_front_anim(var/battle_data/player/target)
	set waitfor=0
	set background=1
	if(!istype(target) || !target.opponent_img)
		return
	return 1

/technique/proc/do_user_rear_anim(var/battle_data/player/target)
	set waitfor=0
	set background=1
	if(!istype(target) || !target.minion_img)
		return
	return 1

/technique/proc/do_target_front_anim(var/battle_data/player/target)
	set waitfor=0
	set background=1
	if(!istype(target) || !target.opponent_img)
		return
	return 1

/technique/proc/do_target_rear_anim(var/battle_data/player/target)
	set waitfor=0
	set background=1
	if(!istype(target) || !target.minion_img)
		return
	return 1
