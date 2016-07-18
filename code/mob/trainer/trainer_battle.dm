/mob/trainer/get_minion()
	if(following && !(following.minion_data.status & STATUS_FAINTED))
		return following.minion_data
	else
		for(var/minion/minion in minions)
			if(!(minion.status & STATUS_FAINTED))
				return minion
	return

/mob/trainer/do_battle_anim()
	if(following)
		following.do_battle_anim()
		return
	. = ..()

/mob/trainer/proc/start_battle(var/battle/battle)

	battle_background.invisibility = 0
	battle_background.mouse_opacity = 2
	current_battle = battle

	spawn(8)
		animate(battle_background, alpha = 160, time = 3)
	spawn(12)
		animate(battle_background, color = "#000000", time = 10)

	if(following)

		var/turf/origin = get_turf(src)
		var/turf/behind = get_step(origin, reverse_dir(dir))

		if(behind)
			following.return_loc = behind
		else
			following.return_loc = get_turf(following)

		following.Move(get_turf(src))
		// Hacking around to get the glide animation to look good.
		src.dir = get_dir(src, following.return_loc)
		src.move_to(following.return_loc)
		spawn(5)
			src.dir = get_dir(src, origin)
			following.dir = src.dir

/mob/trainer/end_battle(var/battle/battle)
	. = ..()

	spawn(0)
		animate(battle_background, alpha = 0, time = 10)
	spawn(10)
		battle_background.invisibility = 100
		battle_background.mouse_opacity = 0
		if(following && following.return_loc)
			src.move_to(get_turf(following))
			if(following.minion_data.data[MD_CHP] <= 0)
				animate(following, alpha=0, time=3)
				sleep(3)
				following.loc = null
			else
				following.move_to(following.return_loc)
		battle_background.color = null
	spawn(20)
		current_battle = null
		// testing purposes only
		for(var/minion/M in minions)
			if(!(M.status & STATUS_FAINTED))
				return
		world << "Having been defeated, \the [src] cheats and has their minions restored."
		restore()
		// testing purposes only

/mob/trainer/restore()
	for(var/minion/M in minions)
		M.restore()
	update_following_minion()

/mob/trainer/clicked(var/client/clicker)
	if(clicker.mob == src)
		return
	var/mob/trainer/trainer = clicker.mob
	if(!istype(trainer))
		return
	if(get_dist(trainer, src) > 1)
		clicker << "You are too far away."
		return
	if(current_battle || !client)
		clicker << "\The [src] cannot battle you at the moment."
		return
	if(!minions.len)
		clicker << "\The [src] has no minions."
		return

	dir = get_dir(src, trainer)
	trainer.dir = get_dir(trainer, src)
	new /battle(list(trainer, src))