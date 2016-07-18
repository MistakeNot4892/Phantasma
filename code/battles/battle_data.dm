/* Structure that handles image tracking and animations for a given player. */
/battle_data
	var/battle/battle
	var/mob/owner
	var/minion/minion

	//todo
	var/list/allied_trainers = list()
	var/list/allied_minions = list()
	var/list/opponent_trainers = list()
	var/list/opponent_minions = list()
	//todo

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

	minion = owner.get_minion()
	if(!minion)
		owner.visible_message("<b>\The [owner]</b> somehow managed to get into a fight with no unfainted minions.")

	opponent_minion = opponent.get_minion()

	if(istype(owner, /mob/minion))
		self_wild_mob = 1
	if(istype(opponent, /mob/minion))
		wild_mob = 1

/battle_data/proc/joined_battle(var/client/C)
	return

/battle_data/proc/update(var/update_minon, var/update_opponent)
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
	if(!minion || !opponent_minion)
		next_action = list("action"="flee")
		return
	var/technique/T = pick(minion.techs)
	next_action = list("action"="tech","ref" = T,"tar" = (T.target_self ? minion : opponent_minion))

/battle_data/proc/get_next_minion()
	if(self_wild_mob)
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
	update(update_minon=1)
	return

/battle_data/proc/update_health()
	return