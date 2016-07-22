/mob
	layer = MOB_LAYER

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
	set_dir(dir)
	if(. && light_obj)
		light_obj.follow_holder()

/mob/destroy()
	current_battle = null
	master_plane = null
	lighting_plane = null
	return ..()

/mob/proc/remove_item(var/data/inventory_item/item, var/amt=1)
	return

/mob/proc/facedir(var/ndir)
	set_dir(ndir)

/mob/verb/eastface()
	set hidden = 1
	set_dir(EAST)

/mob/verb/westface()
	set hidden = 1
	set_dir(WEST)

/mob/verb/northface()
	set hidden = 1
	set_dir(NORTH)

/mob/verb/southface()
	set hidden = 1
	set_dir(SOUTH)

/mob/Login()
	. = ..()
	client.eye = src
	client.perspective = MOB_PERSPECTIVE

	master_plane = new(loc=src)
	lighting_plane = new(loc=src)
	client.images += master_plane
	client.images += lighting_plane

	verbs += /mob/proc/debug_controller
