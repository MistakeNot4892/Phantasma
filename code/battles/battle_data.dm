/* Structure that handles image tracking and animations for a given player. */
/battle_data

	var/battle/battle

	var/mob/owner
	var/minion/minion

	var/list/opponents
	var/list/allies

	var/dummy = 1
	var/wild_mob
	var/suspend_battle = 1
	var/taking_commands = 0
	var/list/next_action = null
	var/team_position

/battle_data/New(var/battle/_battle, var/mob/_owner)
	battle = _battle
	owner = _owner
	minion = owner.get_minion()
	wild_mob = istype(owner, /mob/minion)

/battle_data/proc/initialize()
	return

/battle_data/proc/set_opponents(var/list/_opponents)
	opponents = _opponents

/battle_data/proc/set_allies(var/list/_allies)
	allies = _allies
	team_position = allies.Find(src)-1

/battle_data/proc/update_minion_images(var/update_minon, var/update_opponent)
	return

/battle_data/proc/do_intro_animation()
	set waitfor=0
	set background=1

	spawn(40)

		suspend_battle = 0
		start_turn()

	return

/battle_data/proc/remove_minion()
	return

/battle_data/proc/reveal_minion()
	return

/battle_data/proc/battle_ended()
	set waitfor=0
	set background=1
	owner.end_battle()
	del(src)

/battle_data/proc/do_ai_action()
	if(!minion)
		next_action = list("action"="flee")
		return
	var/technique/T = pick(minion.techs)
	next_action = list("action"="tech","ref" = T,"tar" = (T.target_self ? pick(allies) : pick(opponents)), "hostile_action" = T.is_hostile)

/battle_data/proc/get_next_minion()
	if(wild_mob)
		minion = null
		return
	var/mob/trainer/T = owner
	if(!istype(T))
		return
	minion = null
	for(var/minion/M in T.minions)
		if(!(M.status & STATUS_FAINTED))
			minion = M
			break
	update_minion_images(update_minon=1)
	return

/battle_data/proc/update_health()
	return

/battle_data/proc/do_tech_animations(var/technique/tech, var/battle_data/user, var/battle_data/target)
	return

/battle_data/proc/award_xp(var/val=0)
	return

/battle_data/proc/award_winnings(var/val=0)
	return

/battle_data/proc/destroy()
	battle = null
	owner = null
	minion = null
	opponents.Cut()
	allies.Cut()
	if(next_action)
		next_action.Cut()
	return 1

/battle_data/proc/do_item_animation(var/data/item/template, var/battle_data/target)
	return