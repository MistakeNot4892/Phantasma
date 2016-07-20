#define BUFFER_SIZE 999

/obj/screen/notify
	name = "Notifications"
	icon = 'icons/screen/notify_bar.dmi'
	icon_state = "base"
	plane = SCREEN_PLANE
	maptext_x = 6
	maptext_y = 22
	maptext_width = 608
	maptext_height = 32
	screen_loc = "1,1"
	alpha = 0
	layer = 1

	var/index = 1
	var/list/buffer = list()
	var/list/elements = list()

/obj/screen/notify/New()
	..()
	elements += src
	elements += new /obj/screen/notify_scroll/reset(owner, src)
	elements += new /obj/screen/notify_scroll/up(owner, src)
	elements += new /obj/screen/notify_scroll/down(owner, src)

	for(var/O in elements)
		animate(O, alpha=255,time=5)

/obj/screen/notify/proc/display(var/message)
	if(message)
		buffer.Insert(1,message)
		if(index != 1)
			index++
		if(buffer.len > BUFFER_SIZE)
			buffer.Cut(BUFFER_SIZE+1)
			if(index > buffer.len)
				index = buffer.len
	maptext = "<span style = 'font-family:courier'><font color = '#663931'>[index!=1 ? "<b>[index-1].</b> " : ""][buffer[index]]</font></span>"

/obj/screen/notify_scroll
	icon = 'icons/screen/notify_arrows.dmi'
	screen_loc = "20,1"
	plane = SCREEN_PLANE
	layer = 2
	var/obj/screen/notify/attached

/obj/screen/notify_scroll/clicked(var/client/clicker)
	color = "#AAAAAA"
	do_clicked()
	attached.display()
	sleep(3)
	color = "#FFFFFF"

/obj/screen/notify_scroll/New(var/mob/_owner, var/obj/screen/notify/_attached)
	..(_owner)
	attached = _attached

/obj/screen/notify_scroll/proc/do_clicked()
	return

/obj/screen/notify_scroll/reset
	name = "Reset To Latest"
	icon_state = "reset"

/obj/screen/notify_scroll/reset/do_clicked()
	attached.index = 1

/obj/screen/notify_scroll/up
	name = "Scroll Up"
	icon_state = "up"

/obj/screen/notify_scroll/up/do_clicked()
	attached.index++
	if(attached.index > attached.buffer.len)
		attached.index = attached.buffer.len

/obj/screen/notify_scroll/down
	name = "Scroll Down"
	icon_state = "down"

/obj/screen/notify_scroll/down/do_clicked()
	attached.index--
	if(attached.index < 1)
		attached.index = 1