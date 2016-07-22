var/turf/spawn_turf

/mob/new_player
	name = "new player"
	var/obj/screen/barrier/title/blackout
	var/joining

/mob/new_player/destroy()
	if(blackout)
		if(client)
			client.images -= blackout
		qdel(blackout)
		blackout = null
	if(client && title_image)
		client.screen -= title_image
	return ..()

/mob/new_player/New()
	..()
	loc = null

/mob/new_player/create_hud()

	if(!title_image)
		title_image = new /obj/screen/title()
	if(!blackout)
		blackout = new()

	if(!screen_hud)
		screen_hud = list(
			new /obj/screen/title/option/newgame,
			new /obj/screen/title/option/load,
			new /obj/screen/title/option/settings
			)
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
