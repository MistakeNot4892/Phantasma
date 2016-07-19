/atom/proc/visible_message(var/message)
	for(var/mob/M in range(get_turf(src),world.view))
		M << message
