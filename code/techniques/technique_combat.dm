/technique/combat
	name = "Strike"

	var/damage_value = 20
	var/damage_type = DAM_NEUTRAL
	var/dam_var_min = 0
	var/dam_var_max = 20
	var/crit_chance = 1

/technique/combat/apply_to(var/minion/user, var/minion/target)

	. = TECHNIQUE_FAIL

	if(!..())
		return

	. = TECHNIQUE_SUCCESS

	var/total_damage = damage_value + rand(dam_var_min, dam_var_max)
	total_damage *= (user.data[MD_ATK]/10)
	total_damage -= total_damage * (user.data[MD_DEF]/100)

	if(damage_type in target.template.strong_against)
		. += TECHNIQUE_INEFFECTIVE
		total_damage *= rand(0.5,0.75)
	else if(damage_type in target.template.weak_against)
		. += TECHNIQUE_EFFECTIVE
		total_damage *= rand(1.8,2.2)
	if(prob(crit_chance))
		. += TECHNIQUE_CRITICAL
		total_damage *= rand(2,3)

	if(total_damage <= 0)
		total_damage = 1
	target.data[MD_CHP] -= round(total_damage)
	if(target.data[MD_CHP] <= 0)
		target.data[MD_CHP] = 0

	return .

/technique/combat/do_user_front_anim(var/battle_data/player/target)
	if(!..())
		return
	var/initial_px = target.opponent_img.pixel_x
	animate(target.opponent_img, pixel_x = initial_px + 64, easing = SINE_EASING|EASE_OUT, time = 3)
	sleep(3)
	animate(target.opponent_img, pixel_x = initial_px - 32, easing = SINE_EASING|EASE_IN, time = 3)
	sleep(3)
	animate(target.opponent_img, pixel_x = initial_px, easing = SINE_EASING|EASE_OUT, time = 5)

/technique/combat/do_user_rear_anim(var/battle_data/player/target)
	if(!..())
		return
	var/initial_px = target.minion_img.pixel_x
	animate(target.minion_img, pixel_x = initial_px - 64, easing = SINE_EASING|EASE_OUT, time = 3)
	sleep(3)
	animate(target.minion_img, pixel_x = initial_px, easing = SINE_EASING|EASE_IN, time = 3)

/technique/combat/do_target_front_anim(var/battle_data/player/target)
	if(!..())
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

/technique/combat/do_target_rear_anim(var/battle_data/player/target)
	if(!..())
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

/technique/combat/earth
	name = "Stone Pummel"
	damage_type = DAM_EARTH

/technique/combat/fire
	name = "Fireball"
	damage_type = DAM_FIRE

/technique/combat/water
	name = "Ice Shard"
	damage_type = DAM_WATER

/technique/combat/air
	name = "Air Blade"
	damage_type = DAM_AIR
