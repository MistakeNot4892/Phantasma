/mob
	var/sprinting = 0
	var/next_move = 0
	var/tmp/battle/current_battle

/mob/proc/get_movement_delay()
	return sprinting ? 2	 : 3

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
