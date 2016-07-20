/mob
	plane = MOB_PLANE

	var/sprinting = 0
	var/next_move = 0
	var/tmp/data/battle_controller/current_battle
	glide_size = 4

/mob/proc/get_movement_delay()
	glide_size = sprinting ? 8 : 4
	return sprinting ? 1 : 2

/mob/proc/update_icon()
	return

/mob/Move()
	if(world.time < next_move)
		return 0
	next_move = world.time + get_movement_delay()
	. = ..()

/mob/destroy()
	current_battle = null
	return ..()

/mob/proc/remove_item(var/data/inventory_item/item, var/amt=1)
	return

/mob/proc/facedir(var/ndir)
	dir=ndir

/mob/verb/eastface()
	set hidden = 1
	dir = EAST

/mob/verb/westface()
	set hidden = 1
	dir = WEST

/mob/verb/northface()
	set hidden = 1
	dir = NORTH

/mob/verb/southface()
	set hidden = 1
	dir = SOUTH

/mob/Login()
	. = ..()
	client.eye = src
	client.perspective = MOB_PERSPECTIVE