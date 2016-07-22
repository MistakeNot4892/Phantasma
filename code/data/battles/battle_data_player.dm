/data/battle_data/player
	dummy = 0
	var/client/client
	var/obj/screen/battle_icon/statbar/xp/xp_bar
	var/list/all_objects =             list()
	var/list/menu_objects =            list()
	var/list/technique_objects =       list()
	var/list/item_objects =            list()
	var/list/switch_objects =          list()
	var/list/hp_bars =                 list()
	var/list/hp_objects =              list()

/data/battle_data/player/New(var/data/battle_controller/_battle, var/mob/_owner)
	. = ..()
	client = owner.client

/data/battle_data/player/initialize()

	// Update our team offsets.
	allies_offset = round((64*allies.len)/2)
	opponents_offset = round((64*opponents.len)/2)

	// Create health and XP bars!
	xp_bar = new /obj/screen/battle_icon/statbar/xp(src)
	hp_objects += xp_bar
	hp_objects += xp_bar.mask
	hp_objects += xp_bar.bar

	var/bar_count=0
	for(var/data/battle_data/ally in allies)
		var/obj/screen/battle_icon/statbar/HP = new(ally, bar_count++)
		hp_bars += HP

	bar_count=0
	for(var/data/battle_data/opponent in opponents)
		var/obj/screen/battle_icon/statbar/enemy/HP = new(opponent, bar_count++)
		hp_bars += HP

	for(var/obj/screen/battle_icon/statbar/HP in hp_bars)
		hp_objects += HP
		hp_objects += HP.bar
		hp_objects += HP.mask

	// Create menus!
	menu_objects += new /obj/screen/battle_icon/menu/fight(src)
	menu_objects += new /obj/screen/battle_icon/menu/use_item(src)
	menu_objects += new /obj/screen/battle_icon/menu/switch_out(src)
	menu_objects += new /obj/screen/battle_icon/menu/flee(src)

	for(var/sloc in list("12,4","16,4","12,3","16,3"))
		var/obj/screen/battle_icon/menu/tech/T = new (src)
		T.screen_loc = sloc
		technique_objects += T

	all_objects += menu_objects
	all_objects += technique_objects
	all_objects += item_objects
	all_objects += switch_objects
	all_objects += hp_objects

	initialize_images()

	// Update our client!
	if(client)
		client.screen += all_objects
		for(var/image/I in all_images)
			client.images += I

/data/battle_data/player/remove_minion(var/data/battle_data/minion_owner)
	. = ..()
	var/image/minion_img = minion_images["\ref[minion_owner]"]
	if(minion_img.alpha == 0)
		return
	animate(minion_img, color = "#FF0000", time = 3)
	sleep(3)
	animate(minion_img, alpha=0, time = 5)
	sleep(5)
	update_health()

/data/battle_data/player/reveal_minion(var/data/battle_data/minion_owner)
	. = ..()
	if(minion_owner == src)
		// Clear tech menu.
		for(var/obj/screen/battle_icon/menu/tech/t_menu in technique_objects)
			t_menu.update_tech()
		// Update tech menu.
		if(minion)
			var/i = 1
			for(var/data/technique/T in minion.techs)
				var/obj/screen/battle_icon/menu/tech/t_menu = technique_objects[i]
				t_menu.update_tech(T)
				i++
		else
			return

		if(istype(owner, /mob/trainer))
			var/mob/trainer/T = owner
			T.update_following_minion(minion)

	minion_owner.minion.participated_in_last_fight = 1

	// Update visuals.
	var/image/minion_img = minion_images["\ref[minion_owner]"]
	if(minion_img.alpha == 255)
		return
	minion_img.color = "#FF0000"
	animate(minion_img, alpha=255, time = 5)
	sleep(5)
	animate(minion_img, color = "#FFFFFF", time = 3)
	sleep(5)
	update_health()
	xp_bar.update()

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
		M.color = "#FFFFFF"

	for(var/obj/O in menu_objects)
		animate(O, alpha = 255, time = 3)

	owner.notify("<b>Select an action.</b>")

/data/battle_data/player/end_turn()
	. = ..()
	for(var/obj/O in all_objects-hp_objects)
		animate(O, alpha = 0, time = 3)

/data/battle_data/player/proc/try_item()
	var/mob/trainer/trainer = owner

	if(!trainer.inventory.len)
		owner.notify("You don't have any items.")
		return

	var/chosen_item = input("Which item do you wish to use?") as null|anything in trainer.inventory
	if(!chosen_item)
		return

	var/data/inventory_item/use_item = trainer.inventory[chosen_item]
	if(!use_item.template.can_use_battle)
		owner.notify("You can't use \the [use_item.template.name] in battle!")
		return

	var/data/battle_data/target
	var/list/check_targets = list()
	var/list/possible_targets = list()

	if(use_item.template.hostile)
		check_targets = opponents
	else
		check_targets = allies

	var/i=1
	for(var/data/battle_data/possible_target in check_targets)
		if(possible_target.minion && !(possible_target.minion.status & STATUS_FAINTED))
			possible_targets["[i]. [possible_target.minion.name]"] = possible_target
		i++

	if(!possible_targets.len)
		owner.notify("There are no suitable targets for \the [use_item.template.name].")
		return

	if(possible_targets.len == 1)
		target = possible_targets[possible_targets[1]]
	else
		var/chosen_target = input("Who do you wish to use this item on?") as null|anything in possible_targets
		if(!chosen_target)
			return
		target = possible_targets[chosen_target]

	next_action = list("action" = "item", "ref" = use_item, "target" = target, "hostile_action" = use_item.template.hostile)
	end_turn()
	return 1

/data/battle_data/player/proc/try_switch()
	var/mob/trainer/T = owner
	var/list/usable_minions = list()
	var/i=0
	for(var/data/minion/M in T.minions)
		i++
		if(M == minion || (M.status & STATUS_FAINTED))
			continue
		usable_minions["[i]. [M.name]"] = M

	if(!usable_minions.len)
		owner.notify("You have no other fit minions!")
		return

	var/switching_to = input("Select a replacement.") as null|anything in usable_minions
	if(!switching_to)
		return
	next_action = list("action" = "switch", "ref" = usable_minions[switching_to])
	end_turn()
	return 1

/data/battle_data/player/update_health()
	for(var/obj/screen/battle_icon/statbar/HP in hp_bars)
		HP.update()

/data/battle_data/player/battle_ended()
	taking_commands = 0
	for(var/obj/O in all_objects)
		animate(O, alpha = 0, time = 5)
	for(var/image/I in all_images)
		animate(I, alpha = 0, time = 5)
	sleep(5)

	if(owner && client && owner.client)
		owner.client.screen -= all_objects
		for(var/image/I in all_images)
			owner.client.images -= I
	..()

/data/battle_data/player/destroy()
	client = null
	minion_backlight = null
	opponent_backlight = null
	all_images.Cut()
	minion_images.Cut()
	opponent_images.Cut()
	trainer_images.Cut()
	opponent_trainer_images.Cut()

	for(var/obj/O in all_objects)
		qdel(O)
	all_objects.Cut()
	menu_objects.Cut()
	technique_objects.Cut()
	item_objects.Cut()
	switch_objects.Cut()
	hp_objects.Cut()
	hp_bars.Cut()
	return ..()

/data/battle_data/player/award_experience(var/data/minion/defeated)
	var/mob/trainer/T = owner
	if(istype(T))
		T.award_experience(get_xp_for(defeated), src)
	return
