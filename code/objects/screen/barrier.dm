/obj/screen/barrier
	name = "\improper Overworld"
	layer = BARRIER_LAYER
	screen_loc = "CENTER"
	icon = 'icons/screen/barrier.dmi'
	icon_state = ""
	alpha = 255
	color = BLACK
	mouse_opacity = 2

/obj/screen/barrier/New()
	var/matrix/M = matrix()
	M.Scale(SCREEN_BARRIER_SIZE)
	transform = M

/obj/screen/barrier/title
	name = "Phantasma"
	layer = SCREEN_EFFECTS_LAYER+0.5
	plane = SCREEN_PLANE