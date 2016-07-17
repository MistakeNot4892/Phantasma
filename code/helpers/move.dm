// placeholder for later
/atom/movable/proc/move_to(var/destination)
	src.loc = destination

/proc/reverse_dir(var/dir)
	switch(dir)
		if(NORTH)
			return SOUTH
		if(EAST)
			return WEST
		if(SOUTH)
			return NORTH
		if(WEST)
			return EAST
		if(NORTHEAST)
			return SOUTHWEST
		if(NORTHWEST)
			return SOUTHEAST
		if(SOUTHEAST)
			return NORTHWEST
		if(SOUTHWEST)
			return NORTHEAST
		else
			return 0
