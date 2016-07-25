/data/battle_data/player
	dummy = 0
	var/client/client
	var/list/all_objects =       list()
	var/list/menu_objects =      list()
	var/list/item_objects =      list()
	var/list/switch_objects =    list()
	var/list/technique_objects = list()
	var/list/hp_objects =        list()
	var/list/hp_images =         list()

/data/battle_data/player/New(var/data/battle_controller/_battle, var/mob/_owner)
	. = ..()
	client = owner.client

/data/battle_data/player/initialize()

	// Update our team offsets.
	allies_offset = round((64*allies.len)/2)
	opponents_offset = round((64*opponents.len)/2)

	// Create menus!
	menu_objects += new /obj/screen/battle_icon/menu/fight(src)
	menu_objects += new /obj/screen/battle_icon/menu/use_item(src)
	menu_objects += new /obj/screen/battle_icon/menu/switch_out(src)
	menu_objects += new /obj/screen/battle_icon/menu/flee(src)

	for(var/sloc in list("12,4","16,4","12,3","16,3"))
		var/obj/screen/battle_icon/menu/tech/T = new (src)
		T.screen_loc = sloc
		technique_objects += T

	hp_objects += new /obj/screen/battle_icon/health/ally/self(src, src, 40, -65)

	var/i = 0
	for(var/data/battle_data/ally in (allies-src))
		hp_objects += new /obj/screen/battle_icon/health/ally(src, ally, 55+(i*15), -27 + (i*38))
		i++
	i=0
	for(var/data/battle_data/opponent in opponents)
		hp_objects += new /obj/screen/battle_icon/health(src, opponent, -300+(i*15), 210 - (i*38))
		i++

	all_objects += menu_objects
	all_objects += technique_objects
	all_objects += item_objects
	all_objects += switch_objects

	initialize_images()

	// Update our client!
	if(client)
		client.screen += all_objects
		for(var/image/I in all_images)
			client.images += I

/data/battle_data/player/remove_minion(var/data/battle_data/minion_owner)
	. = ..()

	for(var/obj/screen/battle_icon/menu/tech/t_menu in technique_objects)
		t_menu.set_tech()

	var/image/minion_img = minion_images["\ref[minion_owner]"]
	if(minion_img.alpha == 0)
		return
	animate(minion_img, color = DARK_RED, time = 3)
	sleep(3)
	animate(minion_img, alpha=0, time = 5)
	sleep(5)
	update_health_images()

/data/battle_data/player/reveal_minion(var/data/battle_data/minion_owner)
	. = ..()

	if(minion_owner == src)
		if(!minion)
			return

		var/i=1
		for(var/obj/screen/technique/tech in minion.technique_panels)
			var/obj/screen/battle_icon/menu/tech/t_menu = technique_objects[i]
			t_menu.set_tech(tech)
			i++

		if(istype(owner, /mob/trainer))
			var/mob/trainer/T = owner
			T.update_following_minion(minion)

	minion_owner.minion.participated_in_last_fight = 1

	// Update visuals.
	var/image/minion_img = minion_images["\ref[minion_owner]"]
	if(minion_img.alpha == 255)
		return
	minion_img.color = DARK_RED
	animate(minion_img, alpha=255, time = 5)
	sleep(5)
	animate(minion_img, color = WHITE, time = 3)
	sleep(5)
	update_health_images()

/data/battle_data/player/reset_minions()
	if(istype(owner, /mob/trainer))
		var/mob/trainer/T = owner
		for(var/data/minion/M in T.minions)
			M.participated_in_last_fight = 0
	else if(istype(owner, /mob/minion))
		var/mob/minion/M = owner
		M.minion_data.participated_in_last_fight = 0

/data/battle_data/player/start_turn(var/new_turn)
	. = ..()

	for(var/obj/screen/battle_icon/menu/M in all_objects)
		M.toggled = 0
		M.color = WHITE

	for(var/obj/screen/battle_icon/menu/tech/tech in technique_objects)
		tech.set_tech(tech.technique)

	for(var/obj/O in menu_objects)
		animate(O, alpha = 255, time = 3)

	owner.notify("<b>Select an action.</b>")

/data/battle_data/player/end_turn()
	. = ..()
	for(var/obj/O in all_objects)
		animate(O, alpha = 0, time = 3)

/data/battle_data/player/proc/try_item()
	var/mob/trainer/trainer = owner

	if(!trainer.inventory.len)
		owner.notify("You don't have any items.")
		return

	owner.notify("Select an item.")
	var/data/inventory_item/use_item = owner.select_item_from_list(trainer.inventory)
	if(!use_item)
		return

	if(!use_item.item_template.can_use_battle)
		owner.notify("You can't use \the [use_item.item_template.name] in battle!")
		return

	var/data/battle_data/target
	var/list/check_targets = list()
	var/list/possible_targets = list()

	if(use_item.item_template.hostile)
		check_targets = opponents
	else
		check_targets = allies

	for(var/data/battle_data/possible_target in check_targets)
		if(possible_target.minion && !(possible_target.minion.status & STATUS_FAINTED))
			possible_targets[possible_target.minion] = possible_target

	if(!possible_targets.len)
		owner.notify("There are no suitable targets for \the [use_item.item_template.name].")
		return

	if(possible_targets.len == 1)
		target = possible_targets[possible_targets[1]]
	else
		owner.notify("Who do you wish to use this item on?")
		var/chosen_target = owner.select_minion_from_list(possible_targets)
		if(!chosen_target)
			return
		target = possible_targets[chosen_target]

	next_action = list("action" = "item", "ref" = use_item, "target" = target, "hostile_action" = use_item.item_template.hostile, "priority" = MAX_ACTION_PRIORITY)
	end_turn()
	return 1

/data/battle_data/player/proc/try_switch()
	var/mob/trainer/T = owner
	var/list/usable_minions = list()
	for(var/data/minion/M in T.minions)
		if(M != minion && !(M.status & STATUS_FAINTED))
			usable_minions += M

	if(!usable_minions.len)
		owner.notify("You have no other fit combatants!")
		return

	owner.notify("Select a replacement.")
	var/switching_to = owner.select_minion_from_list(usable_minions)
	if(!switching_to)
		return
	next_action = list("action" = "switch", "ref" = switching_to, "priority" = MAX_ACTION_PRIORITY)
	end_turn()
	return 1

/data/battle_data/player/battle_ended()
	taking_commands = 0
	for(var/obj/O in all_objects)
		animate(O, alpha = 0, time = 5)
	for(var/image/I in all_images)
		animate(I, alpha = 0, time = 5)
	for(var/iref in hp_images)
		animate(hp_images[iref], alpha = 0, time = 5)
	sleep(5)

	if(owner && client && owner.client)
		owner.client.screen -= all_objects
		for(var/image/I in all_images)
			owner.client.images -= I
		for(var/iref in hp_images)
			owner.client.images -= hp_images[iref]
	..()

/data/battle_data/player/destroy()
	client = null
	minion_backlight = null
	opponent_backlight = null
	all_images.Cut()
	minion_images.Cut()
	opponent_images.Cut()
	trainer_images.Cut()
	hp_images.Cut()
	opponent_trainer_images.Cut()

	for(var/obj/O in (all_objects+hp_objects))
		qdel(O)

	hp_objects.Cut()
	all_objects.Cut()
	menu_objects.Cut()
	item_objects.Cut()
	switch_objects.Cut()
	return ..()

/data/battle_data/player/award_experience(var/data/minion/defeated, var/wild_mob)
	var/mob/trainer/T = owner
	if(istype(T))
		T.award_experience(get_xp_for(defeated, wild_mob), src)
	return

/data/battle_data/player/get_next_minion()
	var/mob/trainer/T = owner
	if(!istype(T))
		return
	minion = null
	var/list/usable_minions = list()
	for(var/data/minion/M in T.minions)
		if(!(M.status & STATUS_FAINTED))
			usable_minions  += M
	update_minion_images(update_minon=1)
	if(usable_minions.len)
		owner.notify("Select a replacement.")
		minion = owner.select_minion_from_list(usable_minions, can_cancel=0)
	return minion
