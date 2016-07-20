/mob/npc
	name = "placeholder villager"
	icon = 'icons/overworld/trainer.dmi'
	icon_state = "trainer"

	var/busy
	var/dialogue_string = "Hi! I'm entirely brainless! Can you find me thirty bear butts?"
	var/interaction_delay = 25
	var/previous_dir = 0

/mob/npc/proc/interact(var/mob/person)
	busy = 1
	if(person)
		previous_dir = dir
		dir = get_dir(src, person)
		person.dir = get_dir(person, src)
	if(dialogue_string)
		say(dialogue_string)
	sleep(interaction_delay)
	do_after_interaction()

/mob/npc/proc/do_after_interaction()
	busy = 0
	dir = previous_dir
	return

/mob/npc/clicked(var/client/clicker)
	if(busy || !clicker.mob || get_dist(src, clicker.mob) > 1)
		return
	interact(clicker.mob)
