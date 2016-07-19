#define BATTLE_STARTING 0
#define BATTLE_IN_PROGRESS 1
#define BATTLE_ENDING 2

/battle
	// State data.
	var/tmp/battle_state = BATTLE_STARTING
	var/tmp/environment_type
	var/tmp/battle_tick_delay = 5
	var/tmp/turf/central_turf

	// Player data.
	var/tmp/list/players =  list()
	var/tmp/list/team_one = list()
	var/tmp/list/team_two = list()

/battle/New(var/list/_participants_one, var/list/_participants_two)

	if(!_participants_one || !_participants_two)
		return

	var/battle_region_x1
	var/battle_region_x2
	var/battle_region_y1
	var/battle_region_y2
	var/battle_region_z

	for(var/mob/M in (_participants_one+_participants_two))

		// Keep track of the general region so we can calculate the central point later.
		battle_region_z = M.z // I really hope this is never a bad assumption to make.
		if(!battle_region_x1 || battle_region_x1 > M.x)
			battle_region_x1 = M.x
		if(!battle_region_y1 || battle_region_y1 > M.y)
			battle_region_y1 = M.y
		if(!battle_region_x2 || battle_region_x2 < M.x)
			battle_region_x2 = M.x
		if(!battle_region_y2 || battle_region_y2 < M.y)
			battle_region_y2 = M.y

		// Generate battle data/assign teams.
		var/battle_data/bd = join_battle(M)
		if(M in _participants_one)
			team_one += bd
		else
			team_two += bd

	// Is there any point continuing?
	if(!players.len || !team_one.len || !team_two.len)
		return

	// Continue initializing player/team data.
	for(var/battle_data/player in team_one)
		player.set_allies(team_one)
		player.set_opponents(team_two)
	for(var/battle_data/player in team_two)
		player.set_allies(team_two)
		player.set_opponents(team_one)

	// Find our central turf (so that we can display messages and the battle has an environment).
	central_turf = locate(round((battle_region_x1+battle_region_x2)/2), round((battle_region_y1+battle_region_y2)/2), battle_region_z)
	environment_type = central_turf.battle_environment

	// Finalize initialization of player data.
	for(var/battle_data/player in players)
		player.initialize()

	// Let's get started.
	start_battle()

/battle/proc/start_battle()

	battle_state = BATTLE_IN_PROGRESS

	for(var/battle_data/player in players)
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

			// Is there any point giving this schmuck a turn?
			if(!player.minion || (player.minion.status & STATUS_FAINTED))
				continue

			// Let the AI make a decision about which skill to use.
			if(player.dummy)
				player.do_ai_action()

			// This may be null, since actions like switch/flee don't need it.
			var/battle_data/target = player.next_action["tar"]
			// If we've lost our target, try to update it.
			if(!target || !target.minion)
				var/list/candidates = player.next_action["hostile_action"] ? player.opponents : player.allies
				if(!(target in player.opponents))
					candidates = player.allies
				for(var/battle_data/candidate in candidates)
					if(candidate.minion && !(candidate.minion.status & STATUS_FAINTED))
						target = candidate
						break

			switch(player.next_action["action"])

				if("item")
					var/data/inventory_item/I = player.next_action["ref"]
					central_turf.visible_message("<b>\The [player.owner]</b> uses \the <b>[I.template.name]</b>!")
					sleep(5)
					if(target.minion)
						I.template.apply(target.minion)
						do_item_animation(I.template, target)
						sleep(I.template.battle_use_delay)
						for(var/battle_data/witness in players)
							witness.update_health()
					else
						sleep(5)
						central_turf.visible_message("...but it failed!")
					player.owner.remove_item(I,1)
					sleep(8)

				if("switch")
					remove_minion(player)
					player.minion = player.next_action["ref"]
					player.update_minion_images(1)
					sleep(10)
					reveal_minion(player)
					continue

				if("flee")
					if(can_flee(player))
						central_turf.visible_message("<b>\The [player.owner]</b> is running away!")
						battle_state = BATTLE_ENDING
					else
						central_turf.visible_message("<b>\The [player.owner]</b> tried to escape, but failed!")
					continue

				if("tech")

					var/technique/tech = player.next_action["ref"]
					player.owner.do_battle_anim()
					if(!target || !target.minion)
						if(player.wild_mob)
							central_turf.visible_message("The wild [player.minion.name] used <b>[tech.name]</b>!")
						else
							central_turf.visible_message("\The [player.owner]'s [player.minion.name] used <b>[tech.name]</b>!")
						sleep(12)
						central_turf.visible_message("...but it failed!")
						sleep(8)
						continue

					var/target_descriptor = "itself"
					if(target != player)
						if(target.wild_mob)
							target_descriptor = "\the wild [target.minion.name]"
						else
							if(target in player.allies)
								target_descriptor = "\the allied [target.minion.name]"
							else
								target_descriptor = "\the [target.owner]'s [target.minion.name]"

					if(player.wild_mob)
						central_turf.visible_message("The wild [player.minion.name] used <b>[tech.name]</b> on <b>[target_descriptor]</b>!")
					else
						central_turf.visible_message("\The [player.owner]'s [player.minion.name] used <b>[tech.name]</b> on <b>[target_descriptor]</b>!")

					// Apply the technique and announce the result appropriately.
					var/tech_result = tech.apply_to(player.minion, target.minion)
					if(tech_result == TECHNIQUE_FAIL)
						sleep(12)
						central_turf.visible_message("...but it failed!")
						sleep(8)
						continue

					else if(tech_result & TECHNIQUE_MISSED)
						sleep(12)
						central_turf.visible_message("...but it missed!")
						sleep(8)
						continue

					do_tech_animations(tech, player, target)

					sleep(tech.delay)

					for(var/battle_data/witness in players)
						witness.update_health()

					sleep(8)

					if(tech_result & TECHNIQUE_CRITICAL)
						central_turf.visible_message("A critical hit!")
						sleep(8)

					if(tech_result & TECHNIQUE_INEFFECTIVE)
						central_turf.visible_message("It's not very effective...")
						sleep(8)
					else if(tech_result & TECHNIQUE_EFFECTIVE)
						central_turf.visible_message("It's super effective!")
						sleep(8)

					if(target.minion.data[MD_CHP] <= 0)
						central_turf.visible_message("\The [!target.wild_mob ? "[target.owner]'s" : "wild"] [target.minion] fainted!")
						target.minion.status |= STATUS_FAINTED
						remove_minion(target)
						target.minion = null
						award_experience(target.opponents, target)
						sleep(3)
				else
					central_turf.visible_message("\The [player.owner] performed action '[player.next_action["action"]]'.")

			if(battle_state == BATTLE_ENDING)
				break

		if(battle_state != BATTLE_ENDING)
			// Check if anyone needs to send in a new minion or if the battle is over.
			for(var/battle_data/player in players)
				if(!player.minion || (player.minion.status & STATUS_FAINTED))
					player.get_next_minion()
					if(player.minion)
						reveal_minion(player)
						sleep(10)

			// Calculate team state and declare a loss/win if needed.
			var/team_one_loss = 1
			var/team_two_loss = 1
			for(var/battle_data/player in team_one)
				if(player.minion && !(player.minion.status & STATUS_FAINTED))
					team_one_loss = 0
					break

			for(var/battle_data/player in team_two)
				if(player.minion && !(player.minion.status & STATUS_FAINTED))
					team_two_loss = 0
					break

			if(team_one_loss && team_two_loss)
				victor = 3
			else if(team_one_loss)
				victor = 2
			else if(team_two_loss)
				victor = 1

			if(victor)
				battle_state = BATTLE_ENDING
			else
				for(var/battle_data/player in players)
					player.start_turn()

		sleep(3)

	// Announce the results.
	if(!victor || victor == 3)
		central_turf.visible_message("The battle is <b>a draw</b>!")
	else if(victor)
		var/list/winning_team
		var/list/losing_team
		if(victor == 1)
			winning_team = team_one
			losing_team = team_two
		else if(victor == 2)
			winning_team = team_two
			losing_team = team_one

		var/list/winning_names = list()
		var/list/losing_names = list()
		for(var/battle_data/player in winning_team)
			winning_names += "\the [player.owner]"
		for(var/battle_data/player in losing_team)
			losing_names += "\the [player.owner]"
		central_turf.visible_message("<b>[capitalize(concat_list(winning_names))]</b> [winning_team.len != 1 ? "have" : "has"] defeated <b>[concat_list(losing_names)]</b>!")
		award_winnings(winning_team, losing_team)

	end_battle()

/battle/proc/join_battle(var/mob/player)
	if(!player)
		return

	// Pre-existing battle entry.
	for(var/battle_data/player/player_data in players)
		if(player_data.owner == player)
			player_data.client = player.client
			return player_data

	var/battle_data/player/temp_pd

	if(istype(player, /mob/trainer))
		if(player.client) // Player.
			temp_pd = new /battle_data/player(src, player)
		else
			temp_pd = new /battle_data(src, player)
		var/mob/trainer/T = player
		T.start_battle(src)
	else // NPC.
		temp_pd = new /battle_data(src, player)

	players += temp_pd
	return temp_pd

/battle/proc/end_battle()
	battle_state = BATTLE_ENDING
	for(var/battle_data/player in players)
		player.battle_ended()
	sleep(100)
	qdel(src)

/battle/proc/dropout(var/mob/trainer/trainer)
	set waitfor=0
	set background=1
	trainer.visible_message("As <b>\the [trainer]</b> has passed out, the battle has been cut short.")
	battle_state = BATTLE_ENDING

/battle/proc/reveal_minion(var/battle_data/player)
	if(!player.wild_mob)
		player.owner.say("Go! [player.minion.name]!")
	for(var/battle_data/witness in players)
		witness.reveal_minion(player)

/battle/proc/remove_minion(var/battle_data/player)
	if(!player.wild_mob)
		player.owner.say("[player.minion.name], come back!")
	for(var/battle_data/witness in players)
		witness.remove_minion(player)

/battle/proc/do_tech_animations(var/technique/tech, var/battle_data/user, var/battle_data/target)
	for(var/battle_data/witness in players)
		witness.do_tech_animations(tech, user, target)

/battle/proc/can_flee(var/battle_data/player)
	return prob(90)

/battle/proc/award_experience(var/list/players, var/battle_data/defeated)
	var/val = 1
	for(var/battle_data/player in players)
		player.award_xp(val)

/battle/proc/award_winnings(var/list/players, var/list/defeated)
	var/val = 1
	for(var/battle_data/player in players)
		player.award_winnings(val)

/battle/proc/destroy()
	central_turf = null
	team_one.Cut()
	team_two.Cut()
	for(var/battle_data/player in players)
		qdel(player)
	players.Cut()
	return 1

/battle/proc/do_item_animation(var/data/item/template, var/battle_data/target)
	for(var/battle_data/player in players)
		player.do_item_animation(template, target)