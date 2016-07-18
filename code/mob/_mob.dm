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

/mob/proc/end_battle()
	set waitfor=0
	set background=1
	return

/mob/proc/do_battle_anim()
	set waitfor=0
	set background=1

	var/last_pixel_x = pixel_x
	var/last_pixel_y = pixel_y
	var/target_pixel_x = pixel_x
	var/target_pixel_y = pixel_y

	if(dir & NORTH)
		target_pixel_y+=8
	if(dir & SOUTH)
		target_pixel_y-=8
	if(dir & EAST)
		target_pixel_x+=8
	if(dir & WEST)
		target_pixel_x-=8

	animate(src, pixel_x = target_pixel_x, pixel_y = target_pixel_y, SINE_EASING|EASE_IN, time = 2)
	sleep(2)
	animate(src, pixel_x = last_pixel_x, pixel_y = last_pixel_y, SINE_EASING|EASE_OUT, time = 2)

/mob/proc/get_minion()
	return