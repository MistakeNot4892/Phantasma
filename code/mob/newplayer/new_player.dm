var/turf/spawn_turf

/mob/new_player
	name = "new player"
	var/obj/screen/barrier/title/blackout
	var/list/buttons
	var/joining

/mob/new_player/destroy()
	if(blackout)
		if(client)
			client.images -= blackout
		qdel(blackout)
		blackout = null
	for(var/obj/O in buttons)
		qdel(O)
	return ..()

/mob/new_player/New()
	loc = null
	blackout = new()

/mob/new_player/Login()
	if(!title_image)
		title_image += new /obj/screen/title()
	if(!buttons)
		buttons = list()
		buttons += new /obj/screen/title/option/newgame()
		buttons += new /obj/screen/title/option/load()
		buttons += new /obj/screen/title/option/settings()

	client.screen += blackout
	client.screen += title_image
	client.screen += buttons

	blackout.alpha = 255
	blackout.mouse_opacity = 1
	spawn(0)
		animate(blackout, alpha=0, time=20)
		sleep(20)
		blackout.mouse_opacity = 0
	. = ..()
