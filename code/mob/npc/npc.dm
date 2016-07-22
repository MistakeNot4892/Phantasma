/mob/npc
	name = "placeholder villager"
	icon = 'icons/overworld/npcs.dmi'
	icon_state = "generic"

	var/busy
	var/dialogue_string = "Hi $NAME!"
	var/interaction_delay = 25
	var/previous_dir = 0

/mob/npc/proc/interact(var/mob/person)
	busy = 1
	if(person)
		previous_dir = dir
		set_dir(get_dir(src, person))
		person.set_dir(get_dir(person, src))
	if(dialogue_string)
		say(replacetext(dialogue_string, "$NAME", person.name))
	sleep(interaction_delay)
	do_after_interaction()

/mob/npc/proc/do_after_interaction()
	busy = 0
	set_dir(previous_dir)
	return

/mob/npc/clicked(var/client/clicker)
	if(busy || !clicker.mob || get_dist(src, clicker.mob) > 1)
		return
	interact(clicker.mob)

/mob/npc/fightmaster
	name = "fightmaster"
	dialogue_string = "FIGHT NOW."

/mob/npc/fightmaster/interact(var/mob/person)
	if(!busy)
		var/mob/trainer/T = person
		if(istype(T))
			spawn(0)
				T.test_battle_proc()
	. = ..()
