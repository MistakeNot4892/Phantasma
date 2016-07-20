var/turf/spawn_turf

/mob/new_player
	name = "new player"
	var/list/buttons

/mob/new_player/destroy()
	for(var/obj/O in buttons)
		qdel(O)
	return ..()

/mob/new_player/New()
	loc = null

/mob/new_player/Login()
	. = ..()
	if(!title_image)
		title_image += new /obj/screen/title()
	if(!buttons)
		buttons = list()
		buttons += new /obj/screen/title/option/newgame()
		buttons += new /obj/screen/title/option/load()
		buttons += new /obj/screen/title/option/settings()

	client.screen += title_image
	client.screen += buttons
