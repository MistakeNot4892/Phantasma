/battle_data/player

	dummy = 0

	var/client/client

	var/image/minion_backlight
	var/image/opponent_backlight

	var/list/all_images =              list()
	var/list/minion_images =           list()
	var/list/opponent_images =         list()
	var/list/trainer_images =          list()
	var/list/opponent_trainer_images = list()

	var/list/all_objects =             list()
	var/list/menu_objects =            list()
	var/list/technique_objects =       list()
	var/list/item_objects =            list()
	var/list/switch_objects =          list()

	var/list/hp_bars =                 list()
	var/list/hp_objects =              list()

	var/opponents_offset = 0
	var/allies_offset = 0

/battle_data/player/New(var/battle/_battle, var/mob/_owner)
	. = ..()
	client = owner.client

/battle_data/player/initialize()

	// Update our team offsets.
	allies_offset = round((64*allies.len)/2)
	opponents_offset = round((64*opponents.len)/2)

	// Make sure all our images are in place.
	update_minion_images(1,1)

	// Create health bars!
	var/bar_count=0
	for(var/battle_data/ally in allies)
		var/obj/battle_icon/healthbar/HP = new(ally, bar_count++)
		hp_bars += HP

	bar_count=0
	for(var/battle_data/opponent in opponents)
		var/obj/battle_icon/healthbar/enemy/HP = new(opponent, bar_count++)
		hp_bars += HP

	for(var/obj/battle_icon/healthbar/HP in hp_bars)
		hp_objects += HP
		hp_objects += HP.bar
		hp_objects += HP.mask

	// Create menus!
	menu_objects += new /obj/battle_icon/menu/fight(src)
	menu_objects += new /obj/battle_icon/menu/use_item(src)
	menu_objects += new /obj/battle_icon/menu/switch_out(src)
	menu_objects += new /obj/battle_icon/menu/flee(src)

	for(var/sloc in list("11,2","15,2","11,1","15,1"))
		var/obj/battle_icon/menu/tech/T = new (src)
		T.screen_loc = sloc
		technique_objects += T

	all_objects += menu_objects
	all_objects += technique_objects
	all_objects += item_objects
	all_objects += switch_objects
	all_objects += hp_objects

	// Create images!
	for(var/battle_data/ally in allies)
		var/image/I = new /image/battle(loc = owner, icon = 'icons/battle/icons_rear.dmi',  icon_state = initial(ally.owner.icon_state))
		trainer_images["\ref[ally]"] = I
		I.pixel_x =  420
		I.pixel_y =  -192
		all_images += I
	for(var/battle_data/opponent in opponents)
		var/image/I = new /image/battle(loc = owner, icon = 'icons/battle/icons_front.dmi',  icon_state = initial(opponent.owner.icon_state))
		trainer_images["\ref[opponent]"] = I
		I.pixel_x = -600
		I.pixel_y = -32
		all_images += I

	minion_backlight = new /image/battle(loc = owner, icon = 'icons/screen/battle_environments.dmi',  icon_state = battle.environment_type)
	minion_backlight.layer-=0.1
	minion_backlight.pixel_x = -300
	minion_backlight.pixel_y = -190
	minion_backlight.alpha = 0
	all_images += minion_backlight

	opponent_backlight = new /image/battle(loc = owner, icon = 'icons/screen/battle_environments.dmi',  icon_state = battle.environment_type)
	opponent_backlight.layer-=0.1
	opponent_backlight.pixel_x = 10
	opponent_backlight.pixel_y = -124
	opponent_backlight.alpha = 0
	var/matrix/M = matrix()
	M.Scale(0.75)
	opponent_backlight.transform = M
	all_images += opponent_backlight

	// Update our client!
	if(client)
		client.screen += all_objects
		for(var/image/I in all_images)
			client.images += I

/battle_data/player/proc/update_images_with(var/list/update_data, var/opponents)

	var/default_x = -320
	var/default_y = -192
	var/use_icon = 'icons/battle/icons_rear.dmi'
	var/use_offset = allies_offset

	if(opponents)
		default_x = 40
		default_y = -40
		use_icon = 'icons/battle/icons_front.dmi'
		use_offset = opponents_offset

	for(var/battle_data/player in update_data)

		var/last_alpha = 0
		var/last_pixel_x = (default_x-((use_offset*(update_data.len)))/2)+(use_offset*player.team_position)
		var/last_pixel_y = default_y
		if(minion_images["\ref[player]"])
			var/image/I = minion_images["\ref[player]"]
			last_alpha = I.alpha
			last_pixel_x = I.pixel_x
			last_pixel_y = I.pixel_y
			client.images -= I
			all_images -= I
		var/image/I = new /image/battle(loc = owner, icon = use_icon,  icon_state = (player.minion ? player.minion.template.icon_state : ""))
		I.alpha = last_alpha
		I.pixel_x = last_pixel_x
		I.pixel_y = last_pixel_y
		minion_images["\ref[player]"] = I
		all_images += I
		client.images += I

/battle_data/player/update_minion_images(var/update_minon, var/update_opponent)
	if(!owner || !client)
		return
	if(update_minon)
		update_images_with(allies)
	if(update_opponent)
		update_images_with(opponents, 1)

/battle_data/player/do_intro_animation()

	. = ..()

	// Animate the backlights.
	spawn(8)
		animate(minion_backlight, alpha=255, time = 5)
		animate(opponent_backlight, alpha=255, time = 5)

	// Opponent trainers/minions appear and throw out their minions.
	for(var/battle_data/opponent in opponents)

		if(opponent.wild_mob)
			var/image/opponent_img = minion_images["\ref[opponent]"]
			if(opponent_img)
				var/target_x = opponent_img.pixel_x
				opponent_img.pixel_x = -600
				opponent_img.alpha = 255
				spawn(15)
					animate(opponent_img, pixel_x = target_x, easing = SINE_EASING|EASE_OUT, time = 15)
		else
			var/image/trainer_img = trainer_images["\ref[opponent]"]
			if(trainer_img)
				spawn(15)
					var/target_x = (50-((opponents_offset*(opponents.len)))/2)+(opponents_offset*opponent.team_position)
					animate(trainer_img, pixel_x = target_x, easing = SINE_EASING|EASE_OUT, time = 15)
				spawn(32)
					animate(trainer_img, pixel_x = 450+(opponents_offset*opponent.team_position), easing = SINE_EASING|EASE_OUT, time = 15)
					opponent.owner.say("Go! [opponent.minion.name]!")
					reveal_minion(opponent)

	// Allies do the same.
	for(var/battle_data/ally in allies)

		if(ally.wild_mob)
			var/image/minion_img = minion_images["\ref[ally]"]
			if(minion_img)
				var/target_x = minion_img.pixel_x
				minion_img.alpha = 255
				minion_img.pixel_x = 600
				spawn(15)
					animate(minion_img, pixel_x = target_x, easing = SINE_EASING|EASE_OUT, time = 15)
		else
			var/image/trainer_img = trainer_images["\ref[ally]"]
			if(trainer_img)
				spawn(15)
					var/target_x = (-380-((allies_offset*(allies.len)))/2)+(allies_offset*ally.team_position)
					animate(trainer_img, pixel_x = target_x, easing = SINE_EASING|EASE_OUT, time = 15)
				spawn(32)
					animate(trainer_img, pixel_x = -600, easing = SINE_EASING|EASE_OUT, time = 15)
					ally.owner.say("Go! [ally.minion.name]!")
					reveal_minion(ally)

	// Make the health bars appear.
	spawn(10)
		for(var/obj/O in hp_objects)
			animate(O, alpha = 255, time = 5)

/battle_data/player/remove_minion(var/battle_data/minion_owner)
	var/image/minion_img = minion_images["\ref[minion_owner]"]
	spawn(8)
		update_health()
	if(minion_img.alpha == 0)
		return
	animate(minion_img, color = "#FF0000", time = 3)
	sleep(3)
	animate(minion_img, alpha=0, time = 5)
	sleep(5)

/battle_data/player/reveal_minion(var/battle_data/minion_owner)

	update_health()
	if(minion_owner == src)
		// Clear tech menu.
		for(var/obj/battle_icon/menu/tech/t_menu in technique_objects)
			t_menu.update_tech()
		// Update tech menu.
		if(minion)
			var/i = 1
			for(var/technique/T in minion.techs)
				var/obj/battle_icon/menu/tech/t_menu = technique_objects[i]
				t_menu.update_tech(T)
				i++
		else
			return

		if(istype(owner, /mob/trainer))
			var/mob/trainer/T = owner
			T.update_following_minion(minion)

	// Update visuals.
	var/image/minion_img = minion_images["\ref[minion_owner]"]
	if(minion_img.alpha == 255)
		return
	minion_img.color = "#FF0000"
	animate(minion_img, alpha=255, time = 5)
	sleep(5)
	animate(minion_img, color = "#FFFFFF", time = 3)
	sleep(5)

/battle_data/player/start_turn(var/new_turn)
	. = ..()
	for(var/obj/O in menu_objects)
		O.invisibility = 0
		animate(O, alpha = 255, time = 3)

/battle_data/player/end_turn()
	. = ..()
	for(var/obj/O in all_objects-hp_objects)
		animate(O, alpha = 0, time = 3)
		spawn(3)
			O.invisibility = 100

/battle_data/player/proc/try_item()
	owner.visible_message("<b>\The [owner]</b> is trying to use an item.")
	next_action = list("action" = "item")
	end_turn()

/battle_data/player/proc/try_switch()
	var/mob/trainer/T = owner
	var/list/usable_minions = list()
	var/i=0
	for(var/minion/M in T.minions)
		i++
		if(M == minion || (M.status & STATUS_FAINTED))
			continue
		usable_minions["[i]. [M.name]"] = M

	if(!usable_minions.len)
		owner << "You have no other fit minions!"
		return

	var/switching_to = input("Select a replacement.") as null|anything in usable_minions
	if(switching_to)
		next_action = list("action" = "switch", "ref" = usable_minions[switching_to])
		end_turn()

/battle_data/player/update_health()
	for(var/obj/battle_icon/healthbar/HP in hp_bars)
		HP.update()

/battle_data/player/do_tech_animations(var/technique/tech, var/battle_data/user, var/battle_data/target)

	if(user in allies)
		tech.do_user_rear_anim(minion_images["\ref[user]"])
	else
		tech.do_user_front_anim(minion_images["\ref[user]"])

	if(target in allies)
		tech.do_target_rear_anim(minion_images["\ref[target]"])
	else
		tech.do_target_front_anim(minion_images["\ref[target]"])

/battle_data/player/battle_ended()
	taking_commands = 0
	for(var/obj/O in all_objects)
		animate(O, alpha = 0, time = 5)
	for(var/image/I in all_images)
		animate(I, alpha = 0, time = 5)
	sleep(5)

	if(owner && client && owner.client)
		owner.client.screen -= all_objects
		for(var/image/I in all_images)
			owner.client.images -= I
	..()

/battle_data/player/destroy()
	client = null
	minion_backlight = null
	opponent_backlight = null
	all_images.Cut()
	minion_images.Cut()
	opponent_images.Cut()
	trainer_images.Cut()
	opponent_trainer_images.Cut()

	for(var/obj/O in all_objects)
		qdel(O)
	all_objects.Cut()
	menu_objects.Cut()
	technique_objects.Cut()
	item_objects.Cut()
	switch_objects.Cut()
	hp_objects.Cut()
	hp_bars.Cut()
	return ..()