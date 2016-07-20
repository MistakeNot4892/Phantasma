/mob/trainer
	var/list/minions = list()
	var/tmp/max_minions = 6
	var/tmp/mob/minion/following
	var/tmp/show_minions

/mob/trainer/verb/switch_minion()
	if(current_battle)
		return
	var/data/minion/switching = minions[1]
	minions -= switching
	minions += switching
	update_following_minion()

/mob/trainer/proc/update_following_minion(var/data/minion/new_minion)

	if(following && following.minion_data == new_minion)
		return

	if(!new_minion || (new_minion.status & STATUS_FAINTED))
		for(var/data/minion/temp in minions)
			if(temp.status & STATUS_FAINTED)
				continue
			new_minion = temp
			break

	if(following && following.minion_data == new_minion)
		return

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
