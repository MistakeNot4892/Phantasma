#define BATTLE_STARTING 0
#define BATTLE_IN_PROGRESS 1
#define BATTLE_ENDING 2

/battle
	// State data.
	var/battle_state = BATTLE_STARTING

	var/environment_type
	var/tmp/battle_tick_delay = 5

	// Player data.
	var/list/players = list()

	// Temp variables while I work out how to handle multibattles.
	var/mob/player_one
	var/mob/player_two

/battle/New(var/list/_participants)

	if(!_participants)
		return

	player_one = _participants[1]
	player_two = _participants[2]

	for(var/mob/M in _participants)
		if(!environment_type)
			var/turf/T = get_turf(src)
			if(istype(T))
				environment_type = T.battle_environment
		join_battle(M)

	if(!players.len)
		return

	start_battle()

/battle/proc/start_battle()
	battle_state = BATTLE_IN_PROGRESS
	for(var/battle_data/player in players)
		if(!player.self_wild_mob)
			spawn(50)
				player.owner.say("Go! [player.minion.name]!")
		player.do_intro_animation()

	var/battle_data/victor
	while(battle_state != BATTLE_ENDING)

		var/delay
		for(var/battle_data/player in players)
			if(player.suspend_battle || (!player.dummy && isnull(player.next_action)))
				delay = 1
				break

		if(delay)
			sleep(battle_tick_delay)
			continue

		if(battle_state == BATTLE_ENDING)
			break

		// Sort players by speed. Roll for init!
		var/list/sorted_players = list()
		var/list/sorted_player_speed = list()
		for(var/battle_data/player in players)

			if(!player.minion)
				continue

			var/spd = player.minion.get_turn_speed() + player.minion.get_turn_speed_variance()
			if(!sorted_players.len)
				sorted_players += player
				sorted_player_speed += spd
			else
				for(var/i=1 to sorted_players.len)
					if(spd > sorted_player_speed[i])
						sorted_players.Insert(i,player)
						sorted_player_speed.Insert(i,spd)
					else if(i == sorted_players.len)
						sorted_players += player
						sorted_player_speed += spd

		// Proceed with the turn order.
		for(var/battle_data/player in sorted_players)
			if(!player.minion || (player.minion.status & STATUS_FAINTED))
				continue

			if(player.dummy)
				player.do_ai_action()

			switch(player.next_action["action"])
				if("flee")
					player.owner.visible_message("<b>\The [player.owner]</b> ran away!")
					battle_state = BATTLE_ENDING
					continue
				if("tech")
					var/technique/tech = player.next_action["ref"]
					var/minion/target = player.next_action["tar"]
					if(player.self_wild_mob)
						player.owner.visible_message("The wild [player.minion.name] used <b>[tech.name]</b>!")
					else
						player.owner.visible_message("\The [player.owner]'s [player.minion.name] used <b>[tech.name]</b>!")

					player.owner.do_battle_anim()
					if(tech.apply_to(player.minion, target))
						tech.do_user_rear_anim(player)
						tech.do_target_front_anim(player)
						// This is going to need to be worked over for multi-user battles.
						for(var/battle_data/witness in (players-player))
							tech.do_target_rear_anim(witness)
							tech.do_user_front_anim(witness)
						sleep(tech.delay)

						if(target.data[MD_CHP] <= 0)
							player.owner.visible_message("\The [target.owner ? "[target.owner]'s" : "wild"] [target] fainted!")
							target.status |= STATUS_FAINTED
							for(var/battle_data/witness in players)
								if(witness.minion == target)
									if(!witness.self_wild_mob)
										witness.owner.say("[witness.minion.name], come back!")
									witness.remove_minion()
								else if(witness.opponent_minion == target)
									witness.remove_opponent()
							sleep(3)

					else
						player.owner.visible_message("...but it failed!")
						sleep(5)

				else
					player.owner.visible_message("\The [player.owner] performed action '[player.next_action["action"]]'.")

		// Check if anyone needs to send in a new minion.
		for(var/battle_data/player in players)
			if(!player.minion || (player.minion.status & STATUS_FAINTED))
				player.get_next_minion()
				if(player.minion)
					for(var/battle_data/witness in players)
						if(witness == player)
							if(!witness.self_wild_mob)
								witness.owner.say("Go! [player.minion.name]!")
							witness.reveal_minion()
						else if(witness.opponent == player.owner)
							witness.opponent_minion = player.minion
							witness.reveal_opponent()
					sleep(10)
				else
					// TODO: multibattle victory checks.
					for(var/battle_data/witness in players)
						if(witness.owner != player.owner)
							victor = witness
							break
					battle_state = BATTLE_ENDING
					break

		if(battle_state != BATTLE_ENDING)
			for(var/battle_data/player in players)
				player.start_turn()

		sleep(3)

	if(victor)
		victor.owner.visible_message("<b>\The [victor.opponent]</b> was defeated by <b>\the [victor.owner]</b>!")

	end_battle()

/battle/proc/join_battle(var/mob/player)
	if(!player)
		return
	for(var/battle_data/player_data in players)
		if(player_data.owner == player)
			player_data.joined_battle(player.client)
			return

	// Placeholders pending multibattle code.
	if(istype(player, /mob/trainer) && player.client) // Player.
		var/battle_data/player/temp_pd = new /battle_data/player(src, player, (player == player_one ? player_two : player_one))
		players += temp_pd
		temp_pd.joined_battle(player.client)
		var/mob/trainer/T = player
		T.start_battle(src)
	else // NPC.
		players += new /battle_data(src, player, (player == player_one ? player_two : player_one))

/battle/proc/end_battle()
	battle_state = BATTLE_ENDING
	for(var/battle_data/player in players)
		player.battle_ended()
	sleep(100)
	del(src)

/battle/proc/dropout(var/mob/trainer/trainer)
	set waitfor=0
	set background=1
	trainer.visible_message("As <b>\the [trainer]</b> has passed out, the battle has been cut short.")
	end_battle()