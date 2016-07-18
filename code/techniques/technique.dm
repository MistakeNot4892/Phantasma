var/list/techniques_by_path = list()
/proc/get_tech_by_path(var/techpath)
	if(!techniques_by_path[techpath])
		techniques_by_path[techpath] = new techpath()
	return techniques_by_path[techpath]

/technique
	var/name = "Strike"
	var/damage_type = DAM_NEUTRAL
	var/damage_value = 50
	var/max_uses = 5
	var/delay = 25

/technique/proc/apply_to(var/minion/user, var/minion/target)
	if(user.tech_uses[name] <= 0)
		return 0
	user.tech_uses[name]--
	if(damage_value)
		target.data[MD_CHP] -= damage_value
		if(target.data[MD_CHP] <= 0)
			target.data[MD_CHP] = 0
	return 1

/technique/proc/do_user_front_anim(var/battle_data/player/target)

	set waitfor=0
	set background=1

	if(!istype(target) || !target.opponent_img)
		return

	var/initial_px = target.opponent_img.pixel_x
	animate(target.opponent_img, pixel_x = initial_px + 64, easing = SINE_EASING|EASE_OUT, time = 3)
	sleep(3)
	animate(target.opponent_img, pixel_x = initial_px - 32, easing = SINE_EASING|EASE_IN, time = 3)
	sleep(3)
	animate(target.opponent_img, pixel_x = initial_px, easing = SINE_EASING|EASE_OUT, time = 5)

/technique/proc/do_user_rear_anim(var/battle_data/player/target)

	set waitfor=0
	set background=1

	if(!istype(target) || !target.minion_img)
		return

	var/initial_px = target.minion_img.pixel_x
	animate(target.minion_img, pixel_x = initial_px - 64, easing = SINE_EASING|EASE_OUT, time = 3)
	sleep(3)
	animate(target.minion_img, pixel_x = initial_px, easing = SINE_EASING|EASE_IN, time = 3)

/technique/proc/do_target_front_anim(var/battle_data/player/target)

	set waitfor=0
	set background=1

	if(!istype(target) || !target.opponent_img)
		return

	sleep(6)

	var/end_time = world.time + 15
	while(world.time < end_time)
		if(target.opponent_img.alpha == 255)
			target.opponent_img.alpha = 160
		else
			target.opponent_img.alpha = 255
		sleep(1)
	target.opponent_img.alpha = 255

/technique/proc/do_target_rear_anim(var/battle_data/player/target)

	set waitfor=0
	set background=1

	if(!istype(target) || !target.minion_img)
		return

	sleep(6)

	var/end_time = world.time + 15
	while(world.time < end_time)
		if(target.minion_img.alpha == 255)
			target.minion_img.alpha = 160
		else
			target.minion_img.alpha = 255
		sleep(1)
	target.minion_img.alpha = 255

