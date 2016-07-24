/mob/trainer

	name = "placeholder human"
	icon = 'icons/overworld/humans/human.dmi'
	icon_state = "base"

	icon_body = "base"
	var/icon_eyes = "green"
	var/icon_clothes
	var/icon_hair
	var/icon_beard
	var/icon_hat

	var/tmp/obj/screen/barrier/overworld_barrier
	var/tmp/sleeping = 0
	var/tmp/turf/last_loc
	var/tmp/list/starting_minions

/mob/trainer/New()

	if(isnull(starting_minions))
		starting_minions = shuffle_list(typesof(/data/minion_template)-/data/minion_template)
	for(var/mtype in starting_minions)
		minions += new /data/minion(mtype, src)
	update_following_minion()
	update_icon()
	..()

/mob/trainer/Move()

	if(current_battle)
		return // No moving during fights!

	last_loc = get_turf(src)
	. = ..()
	if(following && loc != last_loc)
		following.Move(last_loc)

/mob/trainer/get_movement_delay()
	.= ..()
	if(following)
		following.glide_size = glide_size

/mob/trainer/Login()

	. = ..()
	if(sleeping)
		notify_nearby("<b>\The [src] wakes up!</b>")
	density = 1
	sleeping = 0
	icon_state = initial(icon_state)
	update_icon()
	update_minion_status()

	if(show_minions)
		client.screen += minion_status
	client.screen += overworld_barrier

	spawn(0)
		overworld_barrier.mouse_opacity = 2
		overworld_barrier.color = BLACK
		overworld_barrier.alpha = 255
		animate(overworld_barrier, alpha = 0, time = 10)
		sleep(10)
		overworld_barrier.mouse_opacity = 0


/mob/trainer/Logout()
	. = ..()
	if(current_battle)
		current_battle.dropout(src)
	if(!sleeping)
		notify_nearby("<b>\The [src]</b> falls asleep...")
	density = 0
	sleeping = 1
	update_icon()

/mob/trainer/destroy()
	if(radio)
		qdel(radio)
		radio = null
	overworld_barrier = null
	last_loc = null
	for(var/data/minion/M in minions)
		qdel(M)
	minions.Cut()
	for(var/obj/O in contents)
		qdel(O)
	for(var/thing in inventory)
		var/data/inventory_item/I = inventory[thing]
		inventory[thing] = null
		qdel(I)
	inventory.Cut()
	if(following)
		qdel(following)
		following = null
	return ..()

var/temporary_trainer_count = 100
/mob/trainer/temporary
	name = "figment"

/mob/trainer/temporary/New()
	. = ..()
	name += " #[temporary_trainer_count]"
	temporary_trainer_count++

/mob/trainer/temporary/end_battle()
	density = 0
	spawn(10)
		animate(src,alpha=0,time=5)
	sleep(15)
	qdel(src)
