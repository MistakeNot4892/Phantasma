var/data/daemon/battle/bc

/proc/start_new_battle(var/list/_one, var/list/_two)
	return new /data/battle_controller(_one, _two)

/data/daemon/battle
	name = "battle controller"
	delay = 5
	var/list/battles = list()

/data/daemon/battle/New()
	. = ..()
	if(bc)
		qdel(bc)
	bc = src

/data/daemon/battle/do_work()
	for(var/data/battle_controller/battle in battles)
		if(!battle.suspended())
			battle.process()
			check_suspend()
		if(battle.battle_state == BATTLE_ENDING)
			battle.end_battle()

/data/daemon/battle/status()
	return "[battles.len] battles ongoing"