/atom/proc/notify_nearby(var/message)
	for(var/mob/trainer/M in range(get_turf(src),world.view))
		M.notify(message)

/atom/proc/set_dir(var/newdir)
	dir = newdir
	if(light_obj)
		light_obj.follow_holder_dir()