/obj/effect/grass
	icon = 'icons/terrain/grass.dmi'
	icon_state = "grass_idle"
	lifetime = 15
	var/rise_time

/obj/effect/grass/New()
	rise_time = rand(4,6)
	lifetime += rise_time
	set_dir(pick(NORTH, SOUTH))
	pixel_x = rand(-16, 16)
	. = ..()

/obj/effect/grass/do_effect_anim()
	var/rise_time = rand(4,6)
	animate(src, pixel_y=rand(-8,8), time=rise_time)
	sleep(rise_time)
	icon_state = "grass_flicker"
	animate(src, alpha=0, time = 15)
	sleep(15)
	qdel(src)
