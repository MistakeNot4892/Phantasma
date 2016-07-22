/* Structure that handles image tracking and animations for a given player. */
/data/battle_data

	var/data/battle_controller/battle

	var/mob/owner
	var/data/minion/minion

	var/list/opponents
	var/list/allies

	var/dummy = 1
	var/wild_mob
	var/taking_commands = 0
	var/list/next_action = null
	var/team_position

/data/battle_data/New(var/data/battle_controller/_battle, var/mob/_owner)
	battle = _battle
	owner = _owner
	minion = owner.get_minion()
	wild_mob = istype(owner, /mob/minion)

/data/battle_data/proc/update_minion_image(var/data/battle_data/player)
	return

/data/battle_data/proc/initialize()
	return

/data/battle_data/proc/set_opponents(var/list/_opponents)
	opponents = _opponents

/data/battle_data/proc/set_allies(var/list/_allies)
	allies = _allies
	team_position = allies.Find(src)-1

/data/battle_data/proc/update_minion_images(var/update_minon, var/update_opponent)
	return

/data/battle_data/proc/do_intro_animation()
	set waitfor=0
	set background=1
	start_turn()
	return

/data/battle_data/proc/remove_minion()
	set waitfor = 0
	set background = 1
	return

/data/battle_data/proc/reveal_minion()
	set waitfor = 0
	set background = 1
	return

/data/battle_data/proc/battle_ended()
	set waitfor=0
	set background=1
	owner.end_battle()
	del(src)

/data/battle_data/proc/do_ai_action()
	if(!minion)
		next_action = list("action"="flee")
		return
	var/data/technique/T = pick(minion.techs)
	next_action = list("action"="tech","ref" = T,"tar" = (T.target_self ? pick(allies) : pick(opponents)), "hostile_action" = T.is_hostile)

/data/battle_data/proc/get_next_minion()
	if(wild_mob)
		minion = null
		return
	var/mob/trainer/T = owner
	if(!istype(T))
		return
	minion = null
	for(var/data/minion/M in T.minions)
		if(!(M.status & STATUS_FAINTED))
			minion = M
			break
	update_minion_images(update_minon=1)
	return

/data/battle_data/proc/update_health_images()
	return

/data/battle_data/proc/do_tech_animations(var/data/technique/tech, var/data/battle_data/user, var/data/battle_data/target)
	return

/data/battle_data/proc/award_experience(var/data/minion/defeated)
	return

/data/battle_data/proc/award_winnings(var/val=0)
	return

/data/battle_data/destroy()
	battle = null
	owner = null
	minion = null
	opponents.Cut()
	allies.Cut()
	if(next_action)
		next_action.Cut()
	return ..()

/data/battle_data/proc/do_item_animation(var/data/item/template, var/data/battle_data/target)
	return

/data/battle_data/proc/reset_minions()
	return
