/mob/trainer
	name = "placeholder trainer"
	icon = 'icons/characters/overworld/trainer.dmi'
	icon_state = "trainer"

	var/list/minions = list()
	var/list/inventory = list()
	var/tmp/obj/battle_icon/background/battle_background
	var/tmp/sleeping = 0
	var/tmp/max_minions = 6
	var/tmp/mob/minion/following
	var/tmp/turf/last_loc

/mob/trainer/New()
	for(var/i=1 to 3)
		minions += new /minion(pick(typesof(/minion_template)-/minion_template), src)
	update_following_minion()

	battle_background = new /obj/battle_icon/background()
	battle_background.mouse_opacity = 0
	battle_background.invisibility = 100
	..()

/mob/trainer/Move()

	if(current_battle)
		return // No moving during fights!

	last_loc = get_turf(src)
	. = ..()
	if(following && loc != last_loc)
		following.Move(last_loc)

/mob/trainer/update_icon()
	overlays = null
	if(sleeping)
		icon_state = "[initial(icon_state)]_sleeping"
		overlays |= "sleeping"
	else if(sprinting)
		icon_state = "[initial(icon_state)]_sprinting"
	else
		icon_state = initial(icon_state)

/mob/trainer/Login()
	. = ..()
	client.screen += battle_background
	if(sleeping)
		visible_message("<b>\The [src] wakes up!</b>")
	density = 1
	sleeping = 0
	icon_state = initial(icon_state)
	update_icon()
	create_hud()

/mob/trainer/Logout()
	. = ..()
	if(current_battle)
		current_battle.dropout(src)
	if(!sleeping)
		visible_message("<b>\The [src]</b> falls asleep...")
	density = 0
	sleeping = 1
	update_icon()

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

/mob/trainer/do_battle_anim()
	if(following)
		following.do_battle_anim()
		return
	. = ..()

/mob/trainer/get_minion()
	if(following && !(following.minion_data.status & STATUS_FAINTED))
		return following.minion_data
	else
		for(var/minion/minion in minions)
			if(!(minion.status & STATUS_FAINTED))
				return minion
	return