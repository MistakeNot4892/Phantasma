/obj/effect
	density = 0
	name = ""
	desc = ""
	plane = EFFECTS_PLANE

	var/lifetime = 5

/obj/effect/New(var/newloc, var/_state, var/_lifetime)
	..(newloc)
	if(_state != null)
		icon_state = _state
	if(_lifetime != null)
		lifetime = _lifetime
	destroy_self()

/obj/effect/proc/do_effect_anim()
	return

/obj/effect/proc/destroy_self()
	set background = 1
	set waitfor = 0
	do_effect_anim()
	sleep(lifetime)
	qdel(src)

/obj/effect/speech
	icon = 'icons/overworld/dialogue_overhead_icons.dmi'
	pixel_z = 28
	alpha = 0
	var/fadeout_step = 8

/obj/effect/speech/do_effect_anim()
	animate(src, alpha = 255, pixel_z = pixel_z + fadeout_step, time = lifetime)
	sleep(lifetime)
	animate(src, alpha = 0, pixel_z = pixel_z + fadeout_step, time = lifetime)

/obj/effect/fadeout
	name = ""

/obj/effect/fadeout/New(var/newloc, var/_state, var/_lifetime)
	var/atom/copy = _state
	if(!istype(copy))
		appearance = copy.appearance
	. = ..(newloc, null, _lifetime)

/obj/effect/fadeout/do_effect_anim()
	animate(src, alpha = 0, time = lifetime)
