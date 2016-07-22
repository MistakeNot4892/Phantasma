/data/battle_controller
	// State data.
	var/tmp/battle_state = BATTLE_STARTING
	var/tmp/environment_type
	var/tmp/turf/central_turf

	// Player data.
	var/tmp/list/players =  list()
	var/tmp/list/team_one = list()
	var/tmp/list/team_two = list()
	var/tmp/turn_count = 0
	var/data/battle_data/victor

/data/battle_controller/proc/suspended()
	if(battle_state != BATTLE_IN_PROGRESS)
		return 1
	for(var/data/battle_data/player in players)
		if(!player.dummy && isnull(player.next_action))
			return 1

/data/battle_controller/New(var/list/_participants_one, var/list/_participants_two)

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
		var/data/battle_data/bd = join_battle(M)
		if(M in _participants_one)
			team_one += bd
		else
			team_two += bd

	// Is there any point continuing?
	if(!players.len || !team_one.len || !team_two.len)
		return

	// Continue initializing player/team data.
	for(var/data/battle_data/player in team_one)
		player.set_allies(team_one)
		player.set_opponents(team_two)
	for(var/data/battle_data/player in team_two)
		player.set_allies(team_two)
		player.set_opponents(team_one)

	// Find our central turf (so that we can display messages and the battle has an environment).
	central_turf = locate(round((battle_region_x1+battle_region_x2)/2), round((battle_region_y1+battle_region_y2)/2), battle_region_z)
	environment_type = central_turf.battle_environment

	// Finalize initialization of player data.
	for(var/data/battle_data/player in players)
		player.initialize()

	// Let's get started.
	start_battle()

/data/battle_controller/proc/start_battle()

	set waitfor = 0
	set background = 1

	for(var/data/battle_data/player in players)
		player.reset_minions()
		player.do_intro_animation()

	sleep(50)
	bc.battles |= src
	battle_state = BATTLE_IN_PROGRESS

/data/battle_controller/proc/process()

	set waitfor = 0
	set background = 1

	if(battle_state == BATTLE_ENDING)
		return

	battle_state = BATTLE_TURN_PROGRESSING

	// Sort players by speed. Roll for init!
	var/list/sorted_players = list()
	var/list/sorted_player_speed = list()
	for(var/data/battle_data/player in players)

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
					break
				else if(i == sorted_players.len)
					sorted_players += player
					sorted_player_speed += spd

	// Proceed with the turn order.
	for(var/data/battle_data/player in sorted_players)

		// Is there any point giving this schmuck a turn?
		if(!player.minion || (player.minion.status & STATUS_FAINTED))
			continue

		// Let the AI make a decision about which skill to use.
		if(player.dummy)
			player.do_ai_action()

		// This may be null, since actions like switch/flee don't need it.
		var/data/battle_data/target = player.next_action["tar"]
		// If we've lost our target, try to update it.
		if(!target || !target.minion)
			var/list/candidates = player.next_action["hostile_action"] ? player.opponents : player.allies
			if(!(target in player.opponents))
				candidates = player.allies
			for(var/data/battle_data/candidate in candidates)
				if(candidate.minion && !(candidate.minion.status & STATUS_FAINTED))
					target = candidate
					break

		switch(player.next_action["action"])

			if("item")
				var/data/inventory_item/I = player.next_action["ref"]
				announce("<b>\The [player.owner]</b> uses \the <b>[I.template.name]</b>!")
				sleep(10)
				if(target.minion)
					I.template.apply(target.minion)
					do_item_animation(I.template, target)
					sleep(I.template.battle_use_delay)
					for(var/data/battle_data/witness in players)
						witness.update_health()
				else
					sleep(10)
					announce("...but it failed!")
				player.owner.remove_item(I,1)
				sleep(16)

			if("switch")
				remove_minion(player)
				player.minion = player.next_action["ref"]
				for(var/data/battle_data/witness in players)
					witness.update_minion_image(player)
				sleep(20)
				reveal_minion(player)
				continue

			if("flee")
				if(can_flee(player))
					announce("<b>\The [player.owner]</b> is running away!")
					battle_state = BATTLE_ENDING
				else
					announce("<b>\The [player.owner]</b> tried to escape, but failed!")
				sleep(24)
				continue

			if("tech")

				var/data/technique/tech = player.next_action["ref"]
				player.owner.do_battle_anim()
				if(!target || !target.minion)
					if(player.wild_mob)
						announce("The wild [player.minion.name] used <b>[tech.name]</b>!")
					else
						announce("\The [player.minion.name] used <b>[tech.name]</b>!")
					sleep(24)
					announce("...but it failed!")
					sleep(16)
					continue

				var/target_descriptor = "itself"
				if(target != player)
					if(target.wild_mob)
						target_descriptor = "\the wild [target.minion.name]"
					else
						if(target in player.allies)
							target_descriptor = "\the allied [target.minion.name]"
						else
							target_descriptor = "\the enemy [target.minion.name]"

				if(player.wild_mob)
					announce("The wild [player.minion.name] used <b>[tech.name]</b> on <b>[target_descriptor]</b>!")
				else
					announce("\The [player.minion.name] used <b>[tech.name]</b> on <b>[target_descriptor]</b>!")

				// Apply the technique and announce the result appropriately.
				var/tech_result = tech.apply_to(player.minion, target.minion)
				if(tech_result == TECHNIQUE_FAIL)
					sleep(24)
					announce("...but it failed!")
					sleep(16)
					continue

				else if(tech_result & TECHNIQUE_MISSED)
					sleep(24)
					announce("...but it missed!")
					sleep(16)
					continue

				do_tech_animations(tech, player, target)

				sleep(tech.delay)

				for(var/data/battle_data/witness in players)
					witness.update_health()

				sleep(16)

				if(tech_result & TECHNIQUE_CRITICAL)
					announce("A critical hit!")
					sleep(16)

				if(tech_result & TECHNIQUE_INEFFECTIVE)
					announce("It's not very effective...")
					sleep(16)
				else if(tech_result & TECHNIQUE_EFFECTIVE)
					announce("It's super effective!")
					sleep(16)

				if(target.minion.data[MD_CHP] <= 0)
					announce("\The [!target.wild_mob ? "[target.owner]'s" : "wild"] [target.minion] fainted!")
					target.minion.status |= STATUS_FAINTED
					remove_minion(target)
					sleep(8)
					for(var/data/battle_data/witness in players)
						witness.update_health()
					award_experience(target.opponents, target.minion)
					target.minion = null
					sleep(20)

			else
				announce("\The [player.owner] performed action '[player.next_action["action"]]'.")

		if(battle_state == BATTLE_ENDING)
			break

	if(battle_state != BATTLE_ENDING)

		// Check if anyone needs to send in a new minion or if the battle is over.
		for(var/data/battle_data/player in players)
			if(!player.minion || (player.minion.status & STATUS_FAINTED))
				player.get_next_minion()
				if(player.minion)
					for(var/data/battle_data/witness in players)
						witness.update_minion_image(player)
					reveal_minion(player)
					sleep(20)

		// Calculate team state and declare a loss/win if needed.
		var/team_one_loss = 1
		var/team_two_loss = 1
		for(var/data/battle_data/player in team_one)
			if(player.minion && !(player.minion.status & STATUS_FAINTED))
				team_one_loss = 0
				break

		for(var/data/battle_data/player in team_two)
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
			battle_state = BATTLE_IN_PROGRESS
			for(var/data/battle_data/player in players)
				player.start_turn()

/data/battle_controller/proc/announce(var/message)
	central_turf.notify_nearby("[message]")

/data/battle_controller/proc/join_battle(var/mob/player)
	if(!player)
		return

	// Pre-existing battle entry.
	for(var/data/battle_data/player/player_data in players)
		if(player_data.owner == player)
			player_data.client = player.client
			return player_data

	var/data/battle_data/player/temp_pd

	if(istype(player, /mob/trainer))
		if(player.client) // Player.
			temp_pd = new /data/battle_data/player(src, player)
		else
			temp_pd = new /data/battle_data(src, player)
		var/mob/trainer/T = player
		T.start_battle(src)
	else // NPC.
		temp_pd = new /data/battle_data(src, player)

	players += temp_pd
	return temp_pd

/data/battle_controller/proc/end_battle()

	set waitfor = 0
	set background = 1

	bc.battles -= src
	battle_state = BATTLE_ENDED

	// Announce the results.
	if(!victor || victor == 3)
		announce("The battle is <b>a draw</b>!")
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
		for(var/data/battle_data/player in winning_team)
			winning_names += "\the [player.owner]"
		for(var/data/battle_data/player in losing_team)
			losing_names += "\the [player.owner]"
		announce("<b>[capitalize(concat_list(winning_names))]</b> [winning_team.len != 1 ? "have" : "has"] defeated <b>[concat_list(losing_names)]</b>!")
		award_winnings(winning_team, losing_team)

	for(var/data/battle_data/player in players)
		player.battle_ended()
	sleep(100)
	qdel(src)

/data/battle_controller/proc/dropout(var/mob/trainer/trainer)
	set waitfor=0
	set background=1
	trainer.notify_nearby("As <b>\the [trainer]</b> has passed out, the battle has been cut short.")
	battle_state = BATTLE_ENDING

/data/battle_controller/proc/reveal_minion(var/data/battle_data/player)
	if(!player.wild_mob)
		player.owner.say("Go! [player.minion.name]!")
	for(var/data/battle_data/witness in players)
		witness.reveal_minion(player)
	sleep(10)

/data/battle_controller/proc/remove_minion(var/data/battle_data/player)
	if(!player.wild_mob)
		player.owner.say("[player.minion.name], come back!")
	for(var/data/battle_data/witness in players)
		witness.remove_minion(player)
	sleep(10)

/data/battle_controller/proc/do_tech_animations(var/data/technique/tech, var/data/battle_data/user, var/data/battle_data/target)
	for(var/data/battle_data/witness in players)
		witness.do_tech_animations(tech, user, target)

/data/battle_controller/proc/can_flee(var/data/battle_data/player)
	return prob(90)

/data/battle_controller/proc/award_experience(var/list/players, var/data/minion/defeated)
	for(var/data/battle_data/player in players)
		player.award_experience(defeated)

/data/battle_controller/proc/award_winnings(var/list/players, var/list/defeated)
	var/val = 1
	for(var/data/battle_data/player in players)
		player.award_winnings(val)

/data/battle_controller/destroy()
	central_turf = null
	team_one.Cut()
	team_two.Cut()
	for(var/data/battle_data/player in players)
		qdel(player)
	players.Cut()
	return ..()

/data/battle_controller/proc/do_item_animation(var/data/item/template, var/data/battle_data/target)
	for(var/data/battle_data/player in players)
		player.do_item_animation(template, target)