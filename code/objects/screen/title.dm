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
	color = PALE_GREY
	new_player.create_new_character()
	sleep(3)
	color = WHITE

/obj/screen/title/option/load
	name = "Continue"
	icon_state = "continue"
	screen_loc = "9,3"
	var/disabled = 0

/obj/screen/title/option/load/clicked(var/client/clicker)
	if(disabled)
		return
	var/mob/new_player/new_player = clicker.mob
	if(new_player.joining)
		return
	color = PALE_GREY
	new_player.do_join(clicker.load_trainer(new /mob/trainer))
	color = WHITE

/obj/screen/title/option/settings
	name = "Settings"
	icon_state = "settings"
	screen_loc = "9,2"
