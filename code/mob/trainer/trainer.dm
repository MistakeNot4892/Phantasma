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
	var/list/minions = list()
	var/list/inventory = list()

	var/tmp/max_minions = 6
	var/tmp/mob/minion/following
	var/tmp/list/starting_minions
	var/tmp/held_items = 0
	var/tmp/max_items = 100
	var/tmp/last_save_x
	var/tmp/last_save_y
	var/tmp/last_save_z
	var/tmp/sleeping = 0
	var/tmp/turf/last_loc
	var/tmp/obj/screen/notify/notifications
	var/tmp/obj/screen/barrier/overworld_barrier

	var/tmp/show_minions
	var/tmp/obj/screen/minion_toggle/minion_toggle
	var/tmp/list/minion_status_panels = list()

	var/tmp/inv_index = 1
	var/tmp/show_inventory
	var/tmp/obj/screen/inventory_toggle/inventory_toggle
	var/tmp/list/inventory_panels = list()

	var/tmp/data/minion/viewing_minion
	var/tmp/data/radio/radio

/mob/trainer/New()
	if(isnull(starting_minions))
		starting_minions = list(pick(typesof(/data/minion_template)-/data/minion_template))
	for(var/mtype in starting_minions)
		minions += new /data/minion(mtype, src)
	update_following_minion()
	update_icon()
	..()

/mob/trainer/Move()

	if(frozen)
		return

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
		client.screen += minion_status_panels
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

/mob/trainer/proc/update_inventory_status()

	if(inv_index<1)
		inv_index = 1
	else
		if(inventory.len > 5)
			if(inv_index>(inventory.len-5))
				inv_index = (inventory.len-5)
		else
			if(inv_index > inventory.len)
				inv_index = inventory.len

	var/i = 0
	for(var/obj/screen/inventory_panel/IP in inventory_panels)
		var/effective_index = inv_index+i
		if(inventory.len && effective_index <= inventory.len)
			IP.update_with(effective_index, inventory[inventory[effective_index]])
		else
			IP.clear()
		i++