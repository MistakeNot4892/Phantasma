var/list/title_image
var/turf/spawn_turf

/obj/title
	name = "Phantasma"
	icon = 'icons/screen/title.dmi'
	icon_state = "title"
	screen_loc = "1,1"
	plane = 99
	layer = 1

/obj/title/option
	icon = 'icons/screen/title_options.dmi'
	layer = 2
	screen_loc = "9,4"

/obj/title/option/newgame
	name = "New Game"
	icon_state = "new_game"

/obj/title/option/newgame/clicked(var/client/clicker)
	var/mob/new_player/new_player = clicker.mob
	if(istype(new_player))
		if(!spawn_turf)
			spawn_turf = locate(15,15,1)
		var/mob/trainer/trainer = new(spawn_turf)
		new_player.client.screen -= title_image
		new_player.client.screen -= new_player.buttons
		trainer.key = new_player.key

		qdel(new_player)
		return

/obj/title/option/load
	name = "Continue"
	icon_state = "continue"
	screen_loc = "9,3"

/obj/title/option/settings
	name = "Settings"
	icon_state = "settings"
	screen_loc = "9,2"

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
		title_image += new /obj/title()
	if(!buttons)
		buttons = list()
		buttons += new /obj/title/option/newgame()
		buttons += new /obj/title/option/load()
		buttons += new /obj/title/option/settings()

	client.screen += title_image
	client.screen += buttons
