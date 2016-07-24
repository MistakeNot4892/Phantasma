/obj/terrain
	density = 0
	plane = MASTER_PLANE
	layer = MOB_LAYER-0.2

/obj/terrain/grass
	name = "long grass"
	icon_state = "grass"
	icon = 'icons/terrain/grass.dmi'
	var/encounter_chance = 5
	var/list/can_encounter = list()

/obj/terrain/grass/New()
	. = ..()
	can_encounter = typesof(/data/minion_template)-/data/minion_template

/obj/terrain/grass/proc/puff(var/turf/target, var/min=3, var/max=5)
	if(!target)
		target = get_turf(src)
	for(var/i = 1 to rand(3,5))
		new /obj/effect/grass(target)

/obj/terrain/grass/Uncross(var/atom/movable/crosser)
	puff(min=1,max=3)
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
		puff(T)
		var/mob/minion/wild/encounter = new(T)
		encounter.set_dir(get_dir(encounter,trainer))
		encounter.show_overhead_icon("shout")
		encounters += encounter

	for(var/mob/minion/wild/W in encounters)
		var/encounter_path = pick(can_encounter)
		W.change_to_minion(new /data/minion(encounter_path, W))

	start_new_battle(list(trainer),encounters)
