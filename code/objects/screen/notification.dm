/obj/screen/notify
	name = "Notifications"
	icon = 'icons/screen/notify_bar.dmi'
	icon_state = "base"
	plane = 99
	maptext_x = 12
	maptext_y = 22
	maptext_width = 608
	maptext_height = 32
	screen_loc = "1,1"
	alpha = 0

/obj/screen/notify/New()
	..()
	animate(src, alpha=255,time=5)

/obj/screen/notify/proc/display(var/message)
	maptext = "<font color = '#663931'>[message]</font>"
	var/writing = maptext
	spawn(100)
		if(maptext == writing)
			maptext = null