/obj/terrain
	density = 0
	layer = TURF_LAYER+0.1

/obj/terrain/grass
	name = "long grass"
	icon_state = "grass"
	icon = 'icons/terrain/grass.dmi'
	var/encounter_chance = 10
	var/list/can_encounter = list()

/obj/terrain/grass/New()
	. = ..()
	can_encounter = typesof(/minion_template)-/minion_template

/obj/terrain/grass/Cross(var/atom/movable/crosser)
	. = ..()
	if(locate(/mob/minion) in get_turf(src))
		return 0
	if(!istype(crosser, /mob/trainer))
		return 1
	if(prob(encounter_chance))
		start_random_encounter(crosser)
		return 0

/obj/terrain/grass/proc/start_random_encounter(var/mob/trainer/trainer)
	set waitfor=0
	set background=1

	var/encounter_path = pick(can_encounter)
	var/mob/minion/wild/encounter = new(get_turf(src), new /minion(encounter_path))
	sleep(1)
	encounter.dir = get_dir(encounter,trainer)
	encounter.show_overhead_icon("shout")
	trainer << "<b>A wild [encounter.name]</b> appears!"
	new /battle(list(trainer,encounter))
