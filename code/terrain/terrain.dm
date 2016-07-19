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

/obj/terrain/grass/Uncross(var/atom/movable/crosser)
	if(!istype(crosser, /mob/trainer))
		return ..()
	if(prob(encounter_chance))
		start_random_encounter(crosser)
		return 0
	return ..()

/obj/terrain/grass/proc/start_random_encounter(var/mob/trainer/trainer)
	set waitfor=0
	set background=1

	var/dirs = list(NORTH, SOUTH, EAST, WEST) - reverse_dir(trainer.dir)

	var/list/encounters = list()
	for(var/i=1 to pick(list(1,1,1,1,1,1,1,1,1,1,2,2,2,3)))
		var/spawn_dir = (trainer.dir in dirs) ? trainer.dir : pick(dirs)
		dirs -= spawn_dir
		var/turf/T = get_step(get_turf(src), spawn_dir)
		var/encounter_path = pick(can_encounter)
		var/mob/minion/wild/encounter = new(T, new /minion(encounter_path))
		encounter.dir = get_dir(encounter,trainer)
		encounter.show_overhead_icon("shout")
		encounters += encounter

	var/announcement = capitalize(concat_list(encounters, "a wild "))
	if(encounters.len>1)
		announcement += " appear!"
	else
		announcement += " appears!"
	sleep(1)
	src.visible_message(announcement)

	start_new_battle(list(trainer),encounters)
