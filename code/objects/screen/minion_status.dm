/obj/screen/minion_status
	name = "Minion Status"
	icon = 'icons/screen/selection.dmi'
	icon_state = "base"
	maptext_x = 30
	maptext_y = 12
	maptext_width = 110
	var/data/minion/minion

/obj/screen/minion_status/New(var/data/minion/_minion)
	minion = _minion
	update()

/obj/screen/minion_status/proc/update()
	overlays.Cut()
	maptext = null
	var/list/images_to_use = list()
	images_to_use += image('icons/minions/status_icons.dmi', "[minion.template.icon_state]_static")
	var/use_colour = PALE_BLUE
	if(minion.status & STATUS_PARALYZED)
		use_colour = BRIGHT_YELLOW
		images_to_use += image('icons/minions/status_icons.dmi', "paralyzed")
	if(minion.status & STATUS_POISONED)
		use_colour = PALE_GREEN
		images_to_use += image('icons/minions/status_icons.dmi', "poisoned")
	if(minion.status & STATUS_FAINTED)
		use_colour = DARK_GREY
		images_to_use += image('icons/minions/status_icons.dmi', "fainted")
	overlays += images_to_use
	var/mob/trainer/T = minion.owner
	if(istype(T))
		maptext = "<span style = 'font-family:courier'><font color = '[use_colour]'><b>[T.minions.Find(minion)].</b>[minion.name]</span></font>"
	else
		maptext = "<span style = 'font-family:courier'><font color = '[use_colour]'>[minion.name]</span></font>"
