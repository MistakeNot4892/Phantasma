/atom/proc/destroy()
	return 1

/atom/movable/destroy()
	loc = null
	return ..()

// placeholder for later
/proc/qdel(var/atom/thing)
	thing.destroy()
	del(thing)
