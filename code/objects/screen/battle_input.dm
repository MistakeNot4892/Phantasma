/obj/screen/battle_icon/menu
	icon = 'icons/screen/battle_menu.dmi'
	alpha = 0
	var/data/battle_data/player/battle
	var/toggled = 0

/obj/screen/battle_icon/menu/destroy()
	battle = null
	return ..()

/obj/screen/battle_icon/menu/New(var/data/battle_data/_battle)
	battle = _battle

/obj/screen/battle_icon/menu/clicked(var/client/clicker)
	if((clicker == battle.client) && isnull(battle.next_action) && battle.taking_commands == 1)
		toggled = !toggled
		color = toggled ? "#AAAAAA" : "#FFFFFF"
		return 1

/obj/screen/battle_icon/menu/fight
	name = "\improper Fight"
	icon_state = "fight"
	screen_loc = "12,5"

/obj/screen/battle_icon/menu/fight/clicked(var/client/clicker)
	if(!..())
		return
	for(var/obj/screen/battle_icon/menu/tech/O in battle.technique_objects)
		O.update_tech(O.tech)
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
		color = "#FFFFFF"

/obj/screen/battle_icon/menu/switch_out
	name = "\improper Switch Phantasm"
	icon_state = "switch"
	screen_loc = "16,5"

/obj/screen/battle_icon/menu/switch_out/clicked(var/client/clicker)
	if(!..())
		return
	if(!battle.try_switch())
		toggled = 0
		color = "#FFFFFF"

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
			color = "#FFFFFF"
			return 0

	battle.next_action = list("action" = "flee")
	battle.end_turn()

/obj/screen/battle_icon/menu/tech
	name = "\improper Technique"
	icon = 'icons/screen/technique_menu.dmi'
	maptext_width = 112
	maptext_x = 8
	maptext_y = 6
	var/data/technique/tech

/obj/screen/battle_icon/menu/tech/proc/update_tech(var/data/technique/_tech)
	maptext = null
	tech = _tech
	if(!tech || !battle.minion)
		return
	name = "[tech.name]"
	maptext = "<span style='font-family:courier; font-size:-3pt'><font color = '#cbdbfc'>[tech.name] <b>[battle.minion.tech_uses[tech.name]]</b></font></span>"

/obj/screen/battle_icon/menu/tech/clicked(var/client/clicker)
	if(!..() || !tech)
		return

	var/list/possible_targets
	var/data/battle_data/target
	if(tech.target_self)
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
		var/i = 1
		for(var/data/battle_data/possible_target in possible_targets)
			if(possible_target.minion)
				targets["[i]. [possible_target.minion.name]"] = possible_target
			i++
		if(targets.len>1)
			var/choice = input("Select a target.") as null|anything in targets
			if(!choice)
				toggled = 0
				color = "#FFFFFF"
				return
			target = targets[choice]
		else
			target = targets[targets[1]]

	battle.next_action = list("action" = "tech", "ref" = tech, "tar" = target, "hostile_action" = tech.is_hostile)
	battle.end_turn()
