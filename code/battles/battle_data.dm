/* Structure that handles image tracking and animations for a given player. */
/battle_data
	var/battle/battle
	var/mob/owner
	var/minion/minion
	var/mob/opponent
	var/minion/opponent_minion

	var/dummy = 1
	var/wild_mob
	var/self_wild_mob
	var/suspend_battle = 1
	var/taking_commands = 0
	var/next_action = null

/battle_data/New(var/battle/_battle, var/mob/_owner, var/mob/_opponent)
	battle = _battle
	owner = _owner
	opponent = _opponent

	if(istype(owner, /mob/minion))
		var/mob/minion/M = owner
		minion = M.minion_data
		self_wild_mob = 1
	else
		var/mob/trainer/T = owner
		minion = T.minions[1]

	if(istype(opponent, /mob/minion))
		var/mob/minion/M = opponent
		opponent_minion = M.minion_data
		wild_mob = 1
	else
		var/mob/trainer/T = opponent
		opponent_minion = T.minions[1]

/battle_data/proc/joined_battle(var/client/C)
	return

/battle_data/proc/update(var/update_minon, var/update_opponent, var/update_health_minion, var/update_health_opponent, var/update_self, var/update_other, var/update_backlights)
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

/battle_data/proc/remove_opponent()
	return

/battle_data/proc/reveal_minion()
	return

/battle_data/proc/reveal_opponent()
	return

/battle_data/proc/battle_ended()
	set waitfor=0
	set background=1
	owner.end_battle()
	del(src)

/battle_data/proc/do_ai_action()
	next_action = list("action"="tech","ref" = pick(minion.techs),"tar" = opponent_minion)