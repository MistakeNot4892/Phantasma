/atom/proc/notify_nearby(var/message)
	for(var/mob/trainer/M in range(get_turf(src),world.view))
		M.notify(message)
