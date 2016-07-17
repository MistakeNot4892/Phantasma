/mob/proc/create_hud()
	return

/mob/trainer/create_hud()
	sleep(1)
	client.screen += list(new /obj/screen/menu(src), new /obj/screen/sprint(src))
