var/turf/initial_spawn_turf

/mob/new_player
	name = "new player"
	var/obj/screen/barrier/title/blackout
	var/joining
	var/obj/screen/title/option/load/load

/mob/new_player/destroy()
	if(blackout)
		if(client)
			client.images -= blackout
		qdel(blackout)
		blackout = null
	if(client)
		if(load)
			client.screen -= load
		if(title_image)
			client.screen -= title_image
	if(load)
		qdel(load)
		load = null
	if(new_character_panel)
		qdel(new_character_panel)
		new_character_panel = null
	return ..()

/mob/new_player/New()
	..()
	loc = null

/mob/new_player/Login()
	. = ..()
	if(!length(file("saves/[ckey]")))
		load.disabled = 1
		load.color = PALE_GREY

/mob/new_player/create_hud()

	if(!title_image)
		title_image = new /obj/screen/title()
	if(!blackout)
		blackout = new()

	if(!screen_hud)
		screen_hud = list(
			new /obj/screen/title/option/newgame,
			new /obj/screen/title/option/settings
			)
		load = new
		screen_hud += load
	..()

/mob/new_player/Login()
	client.screen += blackout
	client.screen += title_image
	blackout.alpha = 255
	blackout.mouse_opacity = 1
	spawn(0)
		animate(blackout, alpha=0, time=20)
		sleep(20)
		blackout.mouse_opacity = 0
	. = ..()

/mob/new_player/do_say(var/message)
	var/list/result = format_string_for_speech(src, message)
	next_speech = world.time + 15
	message = "<b>LOBBY:</b> [result[1]]"
	for(var/mob/new_player/listener in mob_list)
		if(listener.client)
			listener << message

/mob/new_player/do_emote(var/message)
	next_speech = world.time + 25
	message = format_and_capitalize("<b>LOBBY:</b> <b>\The [src]</b> [sanitize_text(message)]")
	for(var/mob/new_player/listener in mob_list)
		if(listener.client)
			listener << message

/mob/new_player/proc/do_join(var/mob/trainer/trainer)
	joining = 1
	animate(blackout, alpha = 255, time = 10)
	sleep(10)

	var/spawning_at = locate(trainer.last_save_x, trainer.last_save_y, trainer.last_save_z)
	if(!spawning_at)
		if(!initial_spawn_turf)
			initial_spawn_turf = locate(15,15,1)
		spawning_at = initial_spawn_turf

	trainer.move_to(spawning_at)
	client.screen -= blackout
	client.screen -= title_image
	client.screen -= screen_hud
	trainer.key = key
	trainer.name = name
	qdel(src)
	return
