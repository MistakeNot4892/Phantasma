/mob/minion
	name = "minion"
	desc = "A minion."
	icon = 'icons/minions/overmap.dmi'
	density = 0
	layer = MOB_LAYER-0.1
	pixel_x = -16

	var/wild
	var/data/minion/minion_data
	var/turf/return_loc

/mob/minion/destroy()
	return_loc = null
	minion_data = null
	return ..()

/mob/minion/wild
	wild = 1
	density = 1
	layer = MOB_LAYER

/mob/minion/get_movement_delay()
	return 0

/mob/minion/New(var/newloc, var/data/minion/_data)
	..(newloc)
	if(_data)
		change_to_minion(_data)

/mob/minion/proc/change_to_minion(var/data/minion/_data)
	set waitfor=0
	set background=1
	minion_data = _data
	name = minion_data.name
	animate(src, alpha=0, time = 3)
	sleep(3)
	icon_state = minion_data.template.icon_state
	icon_strings[TRAINER_ICON_BODY] = icon_state

	animate(src, alpha=255, time = 3)
