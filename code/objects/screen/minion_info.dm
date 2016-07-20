/obj/screen/data_panel
	name = "Minion Info"
	icon = 'icons/screen/infopanel.dmi'
	icon_state = "base"
	screen_loc = "7,4"
	layer = 1
	maptext_x = 68
	maptext_y = 100
	maptext_width = 100
	var/data/minion/minion

/obj/screen/data_panel/New(var/data/minion/_minion)
	minion = _minion
	update()

/obj/screen/data_panel/proc/update()
	maptext = null
	if(!minion)
		return
	maptext = "<span style = 'font-family:courier'><font align='center' color = '#663931'>[minion.name]</font></span>"
	overlays.Cut()
	var/image/I = image('icons/battle/icons_front.dmi', minion.template.icon_state)
	I.pixel_x = 16
	I.pixel_y = 80
	overlays += I