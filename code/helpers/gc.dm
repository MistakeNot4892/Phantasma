/atom/proc/destroy()
	if(contents)
		for(var/thing in contents)
			qdel(thing)
	return 1

/atom/movable/destroy()
	loc = null
	return ..()

/data/proc/destroy()
	return 1

// placeholder for later
/proc/qdel(var/thing)
	thing:destroy() // if this runtimes then someone fucked up and should fix it.
