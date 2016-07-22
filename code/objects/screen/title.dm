var/list/title_image

/obj/screen/title
	name = "Phantasma"
	icon = 'icons/screen/title.dmi'
	icon_state = "title"
	screen_loc = "1,1"
	layer = SCREEN_EFFECTS_LAYER+0.1
	plane = SCREEN_PLANE

/obj/screen/title/option
	icon = 'icons/screen/title_options.dmi'
	layer = SCREEN_EFFECTS_LAYER+0.2
	screen_loc = "9,4"

/obj/screen/title/option/newgame
	name = "New Game"
	icon_state = "new_game"

/obj/screen/title/option/newgame/clicked(var/client/clicker)
	var/mob/new_player/new_player = clicker.mob
	if(new_player.joining)
		return

	new_player.joining = 1
	color = PALE_GREY
	animate(new_player.blackout, alpha = 255, time = 10)
	sleep(10)
	if(!spawn_turf)
		spawn_turf = locate(15,15,1)
	var/mob/trainer/trainer = new(spawn_turf)
	new_player.client.screen -= new_player.blackout
	new_player.client.screen -= title_image
	new_player.client.screen -= new_player.screen_hud
	trainer.key = new_player.key
	trainer.name = new_player.name
	qdel(new_player)
	return
	color = WHITE

/obj/screen/title/option/load
	name = "Continue"
	icon_state = "continue"
	screen_loc = "9,3"

/obj/screen/title/option/settings
	name = "Settings"
	icon_state = "settings"
	screen_loc = "9,2"
