/obj/screen/text
	name = ""
	icon_state = "blank"
	mouse_opacity = 0
	layer = BARRIER_LAYER-0.1
	maptext_width = 1000

/obj/screen/text/New(var/message, var/_x = 0, var/_y =0, var/_height = 150, var/_width = 1100, var/_colour = WHITE)
	. = ..(null)
	pixel_x = _x
	pixel_y = _y
	maptext_width = _height
	maptext_height = _width
	color = _colour

/obj/screen/text/proc/set_text(var/message, var/centered=1)
	if(centered)
		message = "<font align='center'>[message]</font>"
	maptext = "<span style = 'font-family:courier'>[message]</span>"
