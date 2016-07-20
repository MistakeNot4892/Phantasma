var/list/title_image

/obj/screen/title
	name = "Phantasma"
	icon = 'icons/screen/title.dmi'
	icon_state = "title"
	screen_loc = "1,1"
	plane = SCREEN_PLANE
	layer = 1

/obj/screen/title/option
	icon = 'icons/screen/title_options.dmi'
	layer = 2
	screen_loc = "9,4"

/obj/screen/title/option/newgame
	name = "New Game"
	icon_state = "new_game"

/obj/screen/title/option/newgame/clicked(var/client/clicker)
	var/mob/new_player/new_player = clicker.mob
	if(new_player.joining)
		return

	new_player.joining = 1
	color = "#AAAAAA"
	sleep(10)
	if(!spawn_turf)
		spawn_turf = locate(15,15,1)
	var/mob/trainer/trainer = new(spawn_turf)
	new_player.client.screen -= title_image
	new_player.client.screen -= new_player.buttons
	trainer.key = new_player.key
	trainer.name = new_player.name
	qdel(new_player)
	return
	color = "#FFFFFF"

/obj/screen/title/option/load
	name = "Continue"
	icon_state = "continue"
	screen_loc = "9,3"

/obj/screen/title/option/settings
	name = "Settings"
	icon_state = "settings"
	screen_loc = "9,2"
