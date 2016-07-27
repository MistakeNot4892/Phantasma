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

/proc/get_xp_for(var/data/minion/defeated, var/wild_mob)
	return (wild_mob ? 1 : 1.5) * defeated.template.xp_value * (defeated.data[MD_LVL])

/mob/trainer/proc/award_experience(var/amt=1, var/data/battle_data/player/battle_data)

	var/list/minions_who_fought = list()
	for(var/data/minion/M in minions)
		if(!(M.status & STATUS_FAINTED) && M.participated_in_last_fight)
			minions_who_fought += M

	if(!minions_who_fought || !minions_who_fought.len)
		return

	var/per_minion = max(1,round(amt/minions_who_fought.len))
	for(var/data/minion/M in minions_who_fought)
		M.gain_exp(per_minion)

/data/minion/proc/gain_exp(var/amt)
	data[MD_EXP] += amt
	owner.notify("<b>\The [name]</b> recieved [amt] experience points!")
	if(data[MD_EXP] >= get_xp_threshold_for(data[MD_LVL]))
		increase_level()

/data/minion/proc/increase_level()

	for(var/val in MD_COMBAT_STATISTICS)
		data[val] += max(0,ceil((template.data[val]/50.0)+genetics[val]))

	data[MD_CHP] = data[MD_MHP]
	data[MD_LVL]++
	sleep(25)
	owner.notify("Ding! <b>\The [name]</b> reached level <b>[data[MD_LVL]]</b>!")
	var/mob/trainer/T = owner
	if(istype(T))
		T.reset_ui()
	sleep(25)
