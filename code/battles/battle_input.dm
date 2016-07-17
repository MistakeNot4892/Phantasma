/obj/battle_icon/menu
	icon = 'icons/screen/battle_menu.dmi'
	alpha = 0
	layer = 25
	plane = 10
	invisibility = 100
	var/battle_data/player/battle

/obj/battle_icon/menu/New(var/battle_data/_battle)
	battle = _battle

/obj/battle_icon/menu/clicked(var/client/clicker)
	return ((clicker == battle.client) && battle.taking_commands)

/obj/battle_icon/menu/fight
	name = "\improper Fight"
	icon_state = "fight"
	screen_loc = "12,3"

/obj/battle_icon/menu/fight/clicked(var/client/clicker)
	if(!..())
		return
	for(var/obj/O in battle.technique_objects)
		O.invisibility = 0
		animate(O, alpha = 255, time = 3)

/obj/battle_icon/menu/use_item
	name = "\improper Use Item"
	icon_state = "item"
	screen_loc = "14,3"

/obj/battle_icon/menu/use_item/clicked(var/client/clicker)
	if(!..())
		return
	battle.try_item()

/obj/battle_icon/menu/switch_out
	name = "\improper Switch Phantasm"
	icon_state = "switch"
	screen_loc = "16,3"

/obj/battle_icon/menu/switch_out/clicked(var/client/clicker)
	if(!..())
		return
	battle.try_switch()

/obj/battle_icon/menu/flee
	name = "\improper Flee"
	icon_state = "flee"
	screen_loc = "18,3"

/obj/battle_icon/menu/flee/clicked(var/client/clicker)
	if(!..())
		return
	battle.next_action = list("action" = "flee")
	battle.end_turn()

/obj/battle_icon/menu/tech
	name = "\improper Technique"
	icon = 'icons/screen/technique_menu.dmi'
	maptext_width = 112
	maptext_x = 8
	maptext_y = 4
	var/technique/tech

/obj/battle_icon/menu/tech/proc/update_tech(var/technique/_tech)
	maptext = null
	tech = _tech
	invisibility = 0
	if(!tech)
		invisibility = 100
		return
	name = "[tech.name]"
	maptext = "[tech.name] \[[battle.minion.tech_uses[tech.name]]/[tech.max_uses]\]"

/obj/battle_icon/menu/tech/clicked(var/client/clicker)
	if(!..())
		return
	battle.next_action = list("action" = "tech", "ref" = tech, "tar" = battle.opponent_minion)
	battle.end_turn()

/battle_data/proc/start_turn()
	next_action = null
	taking_commands = 1

/battle_data/proc/end_turn()
	taking_commands = 0
