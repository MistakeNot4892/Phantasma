/obj/grass
	name = ""
	icon = 'icons/terrain/grass.dmi'
	icon_state = "grass_idle"
	layer = MOB_LAYER + 1
	mouse_opacity = 0

/obj/grass/New()
	..()
	spawn(0)
		dir = pick(NORTH, SOUTH)
		pixel_x = rand(-16, 16)
		var/rise_time = rand(4,6)
		animate(src, pixel_y=rand(-8,8), time=rise_time)
		sleep(rise_time)
		icon_state = "grass_flicker"
		animate(src, alpha=0, time = 15)
		sleep(15)
		qdel(src)

/obj/terrain
	density = 0
	layer = TURF_LAYER+0.1

/obj/terrain/grass
	name = "long grass"
	icon_state = "grass"
	icon = 'icons/terrain/grass.dmi'
	pixel_x = -1
	pixel_y = -1

	var/encounter_chance = 5
	var/list/can_encounter = list()

/obj/terrain/grass/New()
	. = ..()
	can_encounter = typesof(/data/minion_template)-/data/minion_template

/obj/terrain/grass/Uncross(var/atom/movable/crosser)
	for(var/i = 1 to rand(3,5))
		new /obj/grass(get_turf(src))
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
		var/mob/minion/wild/encounter = new(T, new /data/minion(encounter_path))
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
