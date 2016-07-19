/mob/trainer
	var/list/screen_hud = list()

/mob/trainer/create_hud()
	sleep(1)
	screen_hud = list(new /obj/screen/menu(src), new /obj/screen/sprint(src))
