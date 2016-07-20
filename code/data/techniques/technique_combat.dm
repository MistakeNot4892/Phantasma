/proc/get_type_strength(var/tech_type, var/list/target_elements = list())

	// Neutral v. anything or pure same-type damage is neutral.
	if(!target_elements.len || (target_elements.len == 1 && (tech_type in target_elements)))
		return 1

	// TODO: type weakness datums
	var/strong_type
	var/weak_type
	switch(tech_type)
		if(DAM_EARTH)
			strong_type = DAM_WATER
			weak_type =   DAM_AIR
		if(DAM_WATER)
			strong_type = DAM_FIRE
			weak_type =   DAM_EARTH
		if(DAM_FIRE)
			strong_type = DAM_AIR
			weak_type =   DAM_WATER
		if(DAM_AIR)
			strong_type = DAM_EARTH
			weak_type =   DAM_FIRE

	if(!weak_type && !strong_type)
		return 1

	var/strength_score = 1
	for(var/checktype in target_elements)
		if(strong_type == checktype)
			strength_score++
		else if(weak_type == checktype)
			strength_score--

	// TODO: better granularity for dual types.
	if(strength_score>1)
		strength_score = 4
	else if(strength_score<1)
		strength_score = 0.25
	return strength_score

/proc/calculate_technique_damage(var/data/technique/combat/tech, var/data/minion/user, var/data/minion/target)

	var/user_atk = 1
	var/target_def = 1
	if(tech.use_special_values)
		user_atk =     user.data[MD_SPATK] +   user.modifiers[MD_SPATK]
		target_def = target.data[MD_SPDEF] + target.modifiers[MD_SPDEF]
	else
		user_atk =     user.data[MD_ATK] +   user.modifiers[MD_ATK]
		target_def = target.data[MD_DEF] + target.modifiers[MD_DEF]

	// Avoid division by zero.
	if(target_def<=0)
		target_def = 1

	// Calculate type bonuses, crits, etc.
	var/stab = user.get_same_type_attack_bonus(tech.damage_type)
	var/type_str = get_type_strength(tech.damage_type, target.template.elemental_types)
	var/crit = prob((user.data[MD_SPEED]+user.modifiers[MD_SPEED])/512)

	var/techflags = TECHNIQUE_SUCCESS
	if(type_str>1)
		techflags += TECHNIQUE_EFFECTIVE
	else if(type_str<1)
		techflags += TECHNIQUE_INEFFECTIVE
	if(crit)
		techflags += TECHNIQUE_CRITICAL

	var/damage_total = ((2*(user.level + 10))/250)
	damage_total *= (user_atk/target_def)
	damage_total *= (tech.damage_value+2)

	var/modrand = rand(85.0, 100.0)/100.0
	var/mod = stab * type_str * (crit ? 2 : 1) * user.get_misc_damage_mods() * modrand
	damage_total *= mod

	return list(
		"damage" = damage_total,
		"flags" = techflags
		)

/data/technique/combat
	name = "Strike"
	max_uses = 35
	accuracy = 100
	is_hostile = 1

	var/damage_value = 50
	var/damage_type = DAM_NEUTRAL
	var/use_special_values

/data/technique/combat/apply_to(var/data/minion/user, var/data/minion/target)

	var/prev = ..()

	if(prev & (TECHNIQUE_MISSED|TECHNIQUE_FAIL))
		return prev

	var/list/damage_result = calculate_technique_damage(src, user, target)
	var/total_damage = damage_result["damage"]
	if(total_damage < 0)
		total_damage = 0
	target.data[MD_CHP] -= round(total_damage)

	if(target.data[MD_CHP] <= 0)
		target.data[MD_CHP] = 0
	return damage_result["flags"]

/data/technique/combat/do_user_front_anim(var/image/target)
	if(!..())
		return
	var/initial_px = target.pixel_x
	animate(target, pixel_x = initial_px + 64, easing = SINE_EASING|EASE_OUT, time = 3)
	sleep(3)
	animate(target, pixel_x = initial_px - 32, easing = SINE_EASING|EASE_IN, time = 3)
	sleep(3)
	animate(target, pixel_x = initial_px, easing = SINE_EASING|EASE_OUT, time = 5)

/data/technique/combat/do_user_rear_anim(var/image/target)
	if(!..())
		return
	var/initial_px = target.pixel_x
	animate(target, pixel_x = initial_px - 64, easing = SINE_EASING|EASE_OUT, time = 3)
	sleep(3)
	animate(target, pixel_x = initial_px, easing = SINE_EASING|EASE_IN, time = 3)

/data/technique/combat/do_target_front_anim(var/image/target)
	if(!..())
		return
	sleep(6)
	var/end_time = world.time + 15
	while(world.time < end_time)
		if(target.alpha == 255)
			target.alpha = 160
		else
			target.alpha = 255
		sleep(1)
	target.alpha = 255

/data/technique/combat/do_target_rear_anim(var/image/target)
	if(!..())
		return
	sleep(6)
	var/end_time = world.time + 15
	while(world.time < end_time)
		if(target.alpha == 255)
			target.alpha = 160
		else
			target.alpha = 255
		sleep(1)
	target.alpha = 255

/data/technique/combat/earth
	name = "Pummel"
	damage_type = DAM_EARTH
	accuracy = 90
	damage_value = 50
	max_uses = 25

/data/technique/combat/fire
	name = "Fireball"
	damage_type = DAM_FIRE
	damage_value = 40
	max_uses = 25
	use_special_values = 1

/data/technique/combat/air
	name = "Airblade"
	damage_type = DAM_AIR
	damage_value = 40
	max_uses = 25
	use_special_values = 1

/data/technique/combat/water
	name = "Icebolt"
	damage_type = DAM_WATER
	max_uses = 25
	damage_value = 40
