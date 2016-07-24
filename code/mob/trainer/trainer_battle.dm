/mob/trainer/get_minion()
	if(following && !(following.minion_data.status & STATUS_FAINTED))
		return following.minion_data
	else
		for(var/data/minion/minion in minions)
			if(!(minion.status & STATUS_FAINTED))
				return minion
	return

/mob/trainer/do_battle_anim()
	if(following)
		following.do_battle_anim()
		return
	. = ..()

/mob/trainer/proc/start_battle(var/data/battle_controller/battle)

	if(overworld_barrier)
		overworld_barrier.mouse_opacity = 2
		spawn(8)
			overworld_barrier.color = WHITE
			animate(overworld_barrier, alpha = 255, time = 3)
		spawn(12)
			animate(overworld_barrier, alpha = 160, color = BLACK, time = 10)
	current_battle = battle
	frozen = 1

	for(var/obj/screen/minion_panel_button/MS in minion_status)
		MS.color = WHITE
	if(client && viewing_minion)
		client.screen -= viewing_minion.get_info_panel()

	if(following)

		var/turf/origin = get_turf(src)
		var/turf/behind = get_step(origin, reverse_dir(dir))

		if(behind)
			following.return_loc = behind
		else
			following.return_loc = get_turf(following)

		following.Move(get_turf(src))
		// Hacking around to get the glide animation to look good.
		src.set_dir(get_dir(src, following.return_loc))
		src.move_to(following.return_loc)
		spawn(5)
			src.set_dir(get_dir(src, origin))
			following.set_dir(src.dir)

/mob/trainer/end_battle(var/data/battle_controller/battle)
	. = ..()

	animate(overworld_barrier, alpha = 0, time = 10)
	sleep(10)
	overworld_barrier.mouse_opacity = 0
	if(following)
		update_following_minion()
		if(following.return_loc)
			src.move_to(get_turf(following))
			if(following.minion_data.data[MD_CHP] <= 0)
				animate(following, alpha=0, time=3)
				sleep(3)
				following.loc = null
			else
				following.move_to(following.return_loc)
	overworld_barrier.color = null
	sleep(12)
	current_battle = null
	frozen = 0
	update_minion_status()

	for(var/data/minion/M in minions)
		if(!(M.status & STATUS_FAINTED))
			return
	notify_nearby("Having been defeated, <b>\the [src]</b> retreats!")
	return_to_save_point()

/mob/trainer/proc/return_to_save_point()
	frozen = 1

	var/spawning_at = locate(last_save_x, last_save_y, last_save_z)
	if(!spawning_at)
		if(!initial_spawn_turf)
			initial_spawn_turf = locate(15,15,1)
	overworld_barrier.mouse_opacity = 2
	overworld_barrier.color = WHITE
	overworld_barrier.alpha = 0
	animate(src, alpha = 0, time = 5)
	animate(overworld_barrier, alpha = 255, time = 5)
	sleep(5)
	move_to(spawning_at)
	animate(src, alpha=255, time = 5)
	animate(overworld_barrier, alpha = 0, time = 5)
	sleep(5)
	overworld_barrier.mouse_opacity = 0
	frozen = 0

/mob/trainer/restore()
	for(var/data/minion/M in minions)
		M.restore()
	update_following_minion()
	update_minion_status()

/mob/trainer/clicked(var/client/clicker)
	if(clicker.mob == src)
		return
	var/mob/trainer/trainer = clicker.mob
	if(!istype(trainer))
		return
	if(get_dist(trainer, src) > 1)
		clicker.mob.notify("You are too far away.")
		return
	if(frozen || ((key || ckey) && !client))
		clicker.mob.notify("\The [src] cannot battle you at the moment.")
		return
	if(!minions.len)
		clicker.mob.notify("\The [src] has no minions.")
		return

	set_dir(get_dir(src, trainer))
	trainer.set_dir(get_dir(trainer, src))
	start_new_battle(list(trainer), list(src))

/mob/trainer/verb/test_battle_verb()
	set name = "Test Battle"
	set desc = "Start an immediate battle."
	test_battle_proc()

/mob/trainer/proc/test_battle_proc()
	var/num = input("How many opponents?") as num
	if(!num)
		return
	if(num < 1)
		num = 1
	else if(num > 3)
		num = 3

	var/trainer_count = 0
	var/wild_count = 0

	switch(input("What kind of opponents?") as null|anything in list("trainer", "wild", "mixed"))
		if("trainer")
			trainer_count = num
		if("wild")
			wild_count = num
		if("mixed")
			var/each_side = max(1,round(num/2))
			trainer_count = each_side
			wild_count = each_side
		else
			return

	var/list/encounters = list()
	if(wild_count)
		for(var/i=1 to wild_count)
			encounters += new /mob/minion/wild(get_turf(src))

	if(trainer_count)
		for(var/i=1 to trainer_count)
			encounters += new /mob/trainer/temporary(get_turf(src))

	var/list/allies = list(src)
	var/ally_count = input("How many allies?") as num
	if(ally_count < 0)
		ally_count = 0
	else if(ally_count > 2)
		ally_count = 2
	if(ally_count)
		trainer_count = 0
		wild_count = 0

		switch(input("What kind of allies?") as null|anything in list("trainer", "wild", "mixed"))
			if("trainer")
				trainer_count = ally_count
			if("wild")
				wild_count = ally_count
			if("mixed")
				var/each_side = max(1,round(ally_count/2))
				trainer_count = each_side
				wild_count = each_side
			else
				return

		if(wild_count)
			for(var/i=1 to wild_count)
				allies += new /mob/minion/wild(get_turf(src))

		if(trainer_count)
			for(var/i=1 to trainer_count)
				allies += new /mob/trainer/temporary(get_turf(src))

	for(var/mob/minion/wild/W in (encounters+allies))
		var/encounter_path = pick(typesof(/data/minion_template)-/data/minion_template)
		W.change_to_minion(new /data/minion(encounter_path, W))

	if(encounters.len)
		start_new_battle(allies, encounters)