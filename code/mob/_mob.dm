/mob
	layer = MOB_LAYER

	glide_size = 4

	var/tmp/sprinting = 0
	var/tmp/next_move = 0
	var/tmp/data/battle_controller/current_battle
	var/tmp/frozen

	var/list/icon_strings = list(
		TRAINER_ICON_BODY = "base"
		)

/mob/New()
	. = ..()
	create_hud()
	mob_list += src

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
	mob_list -= src
	current_battle = null
	master_plane = null
	lighting_plane = null
	text_show = null
	if(screen_hud)
		if(client)
			client.screen -= screen_hud
		for(var/obj/O in screen_hud)
			qdel(O)
		screen_hud.Cut()
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
	client.screen += screen_hud
	text_show.icon_state = winget(src.client, "inputwindow", "is-visible") == "false" ? "text" : "text_showing"
	verbs += /mob/proc/debug_controller

/mob/proc/get_battle_image(var/mob/holder, var/frontal)
	return new /image/battle/entity(loc=holder)

/mob/proc/select_minion_from_list(var/list/options = list(), var/select_plane = 99, var/select_layer = 99, var/can_cancel=1)
	return pick(options)

/mob/proc/select_item_from_list(var/list/options)
	return pick(options)
