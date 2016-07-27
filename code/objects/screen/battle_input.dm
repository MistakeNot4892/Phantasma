/obj/screen/battle_icon/menu
	icon = 'icons/screen/battle_menu.dmi'
	alpha = 0
	var/toggled = 0

/obj/screen/battle_icon/menu/destroy()
	battle = null
	return ..()

/obj/screen/battle_icon/menu/clicked(var/client/clicker)
	if((clicker == battle.client) && isnull(battle.next_action) && battle.taking_commands == 1)
		toggled = !toggled
		color = toggled ? PALE_GREY : WHITE
		return 1

/obj/screen/battle_icon/menu/fight
	name = "\improper Fight"
	icon_state = "fight"
	screen_loc = "12,5"

/obj/screen/battle_icon/menu/fight/clicked(var/client/clicker)

	if(!..())
		return

	for(var/obj/screen/battle_icon/menu/tech/O in battle.technique_objects)
		O.invisibility = 0
		animate(O, alpha = (toggled ? 255 : 0), time = 3)

/obj/screen/battle_icon/menu/use_item
	name = "\improper Use Item"
	icon_state = "item"
	screen_loc = "14,5"

/obj/screen/battle_icon/menu/use_item/clicked(var/client/clicker)
	if(!..())
		return
	if(!battle.try_item())
		toggled = 0
		color = WHITE

/obj/screen/battle_icon/menu/switch_out
	name = "\improper Switch"
	icon_state = "switch"
	screen_loc = "16,5"

/obj/screen/battle_icon/menu/switch_out/clicked(var/client/clicker)
	if(!..())
		return
	if(!battle.try_switch())
		toggled = 0
		color = WHITE

/obj/screen/battle_icon/menu/flee
	name = "\improper Flee"
	icon_state = "flee"
	screen_loc = "18,5"

/obj/screen/battle_icon/menu/flee/clicked(var/client/clicker)
	if(!..())
		return

	for(var/data/battle_data/enemy in battle.opponents)
		if(!enemy.wild_mob)
			battle.owner.notify("You cannot flee from a formal duel!")
			color = WHITE
			return 0

	battle.next_action = list("action" = "flee", "priority" = MAX_ACTION_PRIORITY)
	battle.end_turn()

/obj/screen/battle_icon/menu/tech
	name = "Technique"
	var/obj/screen/technique/technique

/obj/screen/battle_icon/menu/tech/New()
	. = ..()
	set_tech()

/obj/screen/battle_icon/menu/tech/proc/set_tech(var/obj/screen/technique/_tech)

	if(!_tech)
		technique = null
		invisibility = 100
		return

	technique = _tech
	technique.update_tech()
	var/last_x = pixel_x
	var/last_y = pixel_y
	appearance = technique
	invisibility = 0
	alpha = 0
	color = WHITE
	layer = initial(layer)
	plane = initial(plane)
	pixel_x = last_x
	pixel_y = last_y

/obj/screen/battle_icon/menu/tech/clicked(var/client/clicker)

	if(!..())
		return

	if(!technique)
		return

	var/list/possible_targets
	var/data/battle_data/target
	if(technique.tech.target_self)
		if(battle.allies.len > 1)
			possible_targets = battle.allies
		else
			target = battle.allies[1]
	else
		if(battle.opponents.len > 1)
			possible_targets = battle.opponents
		else
			target = battle.opponents[1]

	if(!target)
		var/list/targets = list()

		for(var/data/battle_data/possible_target in possible_targets)
			if(possible_target.minion)
				targets[possible_target.minion] = possible_target

		if(targets.len>1)
			battle.owner.notify("Select a target.")
			var/data/minion/choice = battle.owner.select_minion_from_list(targets)
			if(!choice)
				toggled = 0
				color = WHITE
				return
			target = targets[choice]
		else
			target = targets[targets[1]]

	battle.next_action = list("action" = "tech", "ref" = technique.tech, "tar" = target, "hostile_action" = technique.tech.is_hostile, "priority" = technique.tech.priority)
	battle.end_turn()
