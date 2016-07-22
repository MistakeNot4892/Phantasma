/var/list/level_totals = list(
	100,
	250,
	500,
	1000,
	2500,
	5000,
	10000,
	25000,
	50000
	)

/proc/get_xp_threshold_for(var/current_level=1)
	if(!current_level)
		current_level = 1
	else
		current_level++
	if(current_level > level_totals.len)
		current_level = level_totals.len
	return level_totals[current_level]

/proc/get_xp_for(var/data/minion/defeated)
	return 50 * (defeated.data[MD_LVL])

/mob/trainer/proc/award_experience(var/amt=1, var/data/battle_data/player/battle_data)

	var/list/minions_who_fought = list()
	for(var/data/minion/M in minions)
		if(!(M.status & STATUS_FAINTED) && M.participated_in_last_fight)
			minions_who_fought += M

	if(!minions_who_fought)
		return

	var/per_minion = max(1,round(amt/minions_who_fought.len))
	for(var/data/minion/M in minions_who_fought)
		M.gain_exp(per_minion)
		if(M == battle_data.minion)
			battle_data.update_health_images()

/data/minion/proc/gain_exp(var/amt)
	data[MD_EXP] += amt
	owner.notify("<b>\The [name]</b> recieved [amt] experience points!")
	if(data[MD_EXP] >= get_xp_threshold_for(data[MD_LVL]))
		data[MD_LVL]++
		sleep(25)
		owner.notify("Ding! <b>\The [name]</b> reached level <b>[data[MD_LVL]]</b>!")
		sleep(25)
