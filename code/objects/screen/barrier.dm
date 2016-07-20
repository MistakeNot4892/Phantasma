/obj/screen/barrier
	name = "\improper Overworld"
	plane = BARRIER_PLANE
	screen_loc = "CENTER"
	icon = 'icons/screen/barrier.dmi'
	icon_state = ""
	alpha = 0

/obj/screen/barrier/New()
	var/matrix/M = matrix()
	M.Scale(25)
	transform = M