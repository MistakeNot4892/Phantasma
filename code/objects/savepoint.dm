/obj/savepoint
	name = "\improper Save Point"
	icon = 'icons/overworld/savepoint.dmi'
	density = 1
	layer = TURF_LAYER

/obj/savepoint/clicked(var/client/clicker)
	if(!istype(clicker.mob, /mob/trainer) || get_dist(clicker.mob, src)>1)
		return
	var/mob/trainer/T = clicker.mob
	T.restore()
	clicker.save_trainer(T, 1)
