/mob/trainer
	var/list/minions = list()
	var/tmp/max_minions = 6
	var/tmp/mob/minion/following

/mob/trainer/verb/switch_minion()
	if(current_battle)
		return
	var/minion/switching = minions[1]
	minions -= switching
	minions += switching
	update_following_minion()

/mob/trainer/verb/show_minion_status()
	if(current_battle)
		return
	src << "<b>Minion status for [src]:</b>"
	var/i=0
	for(var/minion/M in minions)
		i++
		src << "[i]. [M.name] - [M.data[MD_CHP]]/[M.data[MD_MHP]] [(M.status & STATUS_FAINTED) ? "FAINTED" : "Active"]"

/mob/trainer/proc/update_following_minion(var/minion/new_minion)

	if(following && following.minion_data == new_minion)
		return

	if(!new_minion || (new_minion.status & STATUS_FAINTED))
		for(var/minion/temp in minions)
			if(temp.status & STATUS_FAINTED)
				continue
			new_minion = temp

	if(!new_minion)
		if(following)
			spawn(0)
				animate(following, alpha=0, time = 3)
				sleep(3)
				qdel(following)
		return

	if(!following)
		following = new(get_turf(src), new_minion)
		following.density = 0
	else
		following.change_to_minion(new_minion)
