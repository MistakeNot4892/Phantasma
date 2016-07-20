/atom/proc/visible_message(var/message)
	for(var/mob/trainer/M in range(get_turf(src),world.view))
		M.notify(message)
