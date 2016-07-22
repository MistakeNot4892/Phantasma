/mob/trainer

	name = "placeholder human"
	icon = 'icons/overworld/human.dmi'
	icon_state = "base"

	var/tmp/obj/screen/barrier/overworld_barrier
	var/tmp/sleeping = 0
	var/tmp/turf/last_loc

/mob/trainer/New()
	minions += new /data/minion(/data/minion_template/airbird, src)
	minions += new /data/minion(/data/minion_template/firelizard, src)
	minions += new /data/minion(/data/minion_template/earthbug, src)
	minions += new /data/minion(/data/minion_template/waterfish, src)
	update_following_minion()
	..()

/mob/trainer/Move()

	if(current_battle)
		return // No moving during fights!

	last_loc = get_turf(src)
	. = ..()
	if(following && loc != last_loc)
		following.Move(last_loc)

/mob/trainer/update_icon()
	overlays = null
	if(sleeping)
		icon_state = "[initial(icon_state)]_sleeping"
		overlays |= "sleeping"
	else if(sprinting)
		icon_state = "[initial(icon_state)]_sprinting"
	else
		icon_state = initial(icon_state)

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