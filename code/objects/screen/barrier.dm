/obj/screen/barrier
	name = "\improper Overworld"
	plane = BARRIER_PLANE
	screen_loc = "CENTER"
	icon = 'icons/screen/barrier.dmi'
	icon_state = ""
	alpha = 255
	color = "#000000"
	mouse_opacity = 2

/obj/screen/barrier/New()
	var/matrix/M = matrix()
	M.Scale(25)
	transform = M

/obj/screen/barrier/title
	name = "Phantasma"
	plane = SCREEN_EFFECTS_PLANE
