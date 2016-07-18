/battle_data/player

	dummy = 0

	var/image/minion_img
	var/image/minion_hp
	var/image/opponent_img
	var/image/opponent_hp
	var/image/trainer_self
	var/image/trainer_other
	var/image/minion_backlight
	var/image/opponent_backlight
	var/list/all_objects =       list()
	var/list/menu_objects =      list()
	var/list/technique_objects = list()
	var/list/item_objects =      list()
	var/list/switch_objects =    list()
	var/client/client

/battle_data/player/joined_battle(var/client/C)
	if(C.mob != owner)
		return
	client = C
	update(1,1,1,1,1,1,1,1)

/battle_data/player/New(var/battle/_battle, var/mob/_owner)
	. = ..()
	client = owner.client
	menu_objects += new /obj/battle_icon/menu/fight(src)
	menu_objects += new /obj/battle_icon/menu/use_item(src)
	menu_objects += new /obj/battle_icon/menu/switch_out(src)
	menu_objects += new /obj/battle_icon/menu/flee(src)

	for(var/sloc in list("12,2","16,2","12,1","16,1"))
		var/obj/battle_icon/menu/tech/T = new (src)
		T.screen_loc = sloc
		technique_objects += T

	all_objects += menu_objects
	all_objects += technique_objects
	all_objects += item_objects
	all_objects += switch_objects

/battle_data/player/update(var/update_minon, var/update_opponent, var/update_health_minion, var/update_health_opponent, var/update_self, var/update_other, var/update_backlights)
	if(!owner)
		return
	if(update_minon)
		var/last_alpha
		if(minion_img)
			last_alpha = minion_img.alpha
			client.images -= minion_img
		minion_img =  new /image/battle(loc = owner, icon = 'icons/characters/battle_icons_rear.dmi',  icon_state = (minion ? minion.template.icon_state : ""))
		if(!isnull(last_alpha))
			minion_img.alpha = last_alpha
		client.images += minion_img
	if(update_opponent)
		var/last_alpha
		if(opponent_img)
			last_alpha = opponent_img.alpha
			client.images -= opponent_img
		opponent_img = new /image/battle(loc = owner, icon = 'icons/characters/battle_icons_front.dmi', icon_state = (opponent_minion ? opponent_minion.template.icon_state : ""))
		if(!isnull(last_alpha))
			opponent_img.alpha = last_alpha
		client.images += opponent_img
	if(update_health_minion)
		if(minion_hp)
			client.images -= minion_hp
		minion_hp =   new /image/battle(loc = owner, icon = 'icons/screen/battle_hp_underlay.dmi', icon_state = "hp_base")
		minion_hp.layer+=0.1
		client.images += minion_hp
	if(update_health_opponent)
		if(opponent_hp)
			client.images -= opponent_hp
		opponent_hp = new /image/battle(loc = owner, icon = 'icons/screen/battle_hp_underlay.dmi', icon_state = "hp_base")
		opponent_hp.layer+=0.1
		client.images += opponent_hp
	if(update_self)
		if(trainer_self)
			client.images -= trainer_self
		trainer_self = new /image/battle(loc = owner, icon = 'icons/characters/battle_icons_rear.dmi',  icon_state = initial(owner.icon_state))
		client.images += trainer_self
	if(update_other)
		if(trainer_other)
			client.images -= trainer_other
		trainer_other = new /image/battle(loc = owner, icon = 'icons/characters/battle_icons_front.dmi',  icon_state = (!wild_mob ? initial(opponent.icon_state) : ""))
		client.images += trainer_other
	if(update_backlights)
		if(minion_backlight)
			client.images -= minion_backlight
		minion_backlight = new /image/battle(loc = owner, icon = 'icons/screen/battle_environments.dmi',  icon_state = battle.environment_type)
		minion_backlight.layer-=0.1
		client.images += minion_backlight
		if(opponent_backlight)
			client.images -= opponent_backlight
		opponent_backlight = new /image/battle(loc = owner, icon = 'icons/screen/battle_environments.dmi',  icon_state = battle.environment_type)
		opponent_backlight.layer-=0.1
		var/matrix/M = matrix()
		M.Scale(0.75)
		opponent_backlight.transform = M
		client.images += opponent_backlight

/battle_data/player/do_intro_animation()

	. = ..()

	client.screen += all_objects

	opponent_img.pixel_x = -600
	opponent_img.pixel_y = -40
	minion_img.pixel_x =  -320
	minion_img.pixel_y =  -192
	minion_img.alpha = 0
	minion_hp.pixel_x = 520
	minion_hp.pixel_y = -96
	opponent_hp.pixel_x = -620
	opponent_hp.pixel_y = 148

	minion_backlight.pixel_x = -300
	minion_backlight.pixel_y = -190
	opponent_backlight.pixel_x = 50
	opponent_backlight.pixel_y = -124
	minion_backlight.alpha = 0
	opponent_backlight.alpha = 0

	trainer_self.pixel_x =  420
	trainer_self.pixel_y =  -192
	trainer_other.pixel_x = -600
	trainer_other.pixel_y = -42

	spawn(10)
		animate(minion_hp, pixel_x = 32, easing = SINE_EASING|EASE_OUT, time = 10)
		animate(opponent_hp, pixel_x = -300, easing = SINE_EASING|EASE_OUT, time = 10)

	spawn(15)
		animate(minion_backlight, alpha = 255, time = 8)
		animate(opponent_backlight, alpha = 255, time = 8)

	spawn(20)
		if(!wild_mob)
			animate(trainer_other, pixel_x = 50, easing = SINE_EASING|EASE_OUT, time = 15)
		else
			animate(opponent_img, pixel_x = 40, easing = SINE_EASING|EASE_OUT, time = 15)
		animate(trainer_self, pixel_x = -380, easing = SINE_EASING|EASE_OUT, time = 15)

	spawn(40)

		// Trainer throws out their minion.
		animate(trainer_self, pixel_x = -600, easing = SINE_EASING|EASE_OUT, time = 15)
		reveal_minion()

		// If we aren't fighting a wild minion, opponent throws out their minion and fucks off.
		if(!wild_mob)
			animate(trainer_other, pixel_x = 450, easing = SINE_EASING|EASE_OUT, time = 15)
			reveal_opponent()

		suspend_battle = 0
		start_turn()

/battle_data/player/remove_minion()

	animate(minion_img, color = "#FF0000", time = 3)
	sleep(3)
	animate(minion_img, alpha=0, time = 5)
	sleep(5)

/battle_data/player/remove_opponent()
	animate(opponent_img, color = "#FF0000", time = 3)
	sleep(3)
	animate(opponent_img, alpha=0, time = 5)
	sleep(5)

/battle_data/player/reveal_minion()

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

	update(update_minon=1)

	// Update visuals.
	minion_img.pixel_x =  -320
	minion_img.pixel_y =  -192
	minion_img.alpha = 0
	minion_img.invisibility = 0

	minion_img.color = "#FF0000"
	animate(minion_img, alpha=255, time = 5)
	sleep(5)
	animate(minion_img, color = "#FFFFFF", time = 3)
	sleep(5)


/battle_data/player/reveal_opponent()

	update(update_opponent=1)

	opponent_img.pixel_x = 40
	opponent_img.pixel_y = -40
	opponent_img.invisibility = 0
	opponent_img.alpha = 0
	opponent_img.color = "#FF0000"
	animate(opponent_img, alpha=255, time = 5)
	sleep(5)
	animate(opponent_img, color = "#FFFFFF", time = 3)
	sleep(3)

/battle_data/player/battle_ended()

	taking_commands = 0

	animate(minion_img, alpha = 0, time = 5)
	animate(minion_hp, alpha = 0, time = 5)
	animate(opponent_img, alpha = 0, time = 5)
	animate(opponent_hp, alpha = 0, time = 5)
	animate(trainer_self, alpha = 0, time = 5)
	animate(trainer_other, alpha = 0, time = 5)
	animate(minion_backlight, alpha = 0, time = 5)
	animate(opponent_backlight, alpha = 0, time = 5)

	sleep(5)

	if(owner && client)
		client.images -= minion_img
		client.images -= minion_hp
		client.images -= opponent_img
		client.images -= opponent_hp
		client.images -= trainer_self
		client.images -= trainer_other
		client.images -= minion_backlight
		client.images -= opponent_backlight
		client.screen -= all_objects
		client.screen -= technique_objects

	..()

/battle_data/player/start_turn(var/new_turn)
	. = ..()
	for(var/obj/O in menu_objects)
		O.invisibility = 0
		animate(O, alpha = 255, time = 3)

/battle_data/player/end_turn()
	. = ..()
	for(var/obj/O in all_objects)
		animate(O, alpha = 0, time = 3)
		spawn(3)
			O.invisibility = 100

/battle_data/player/proc/try_item()
	owner.visible_message("<b>\The [owner]</b> is trying to use an item.")
	next_action = list("action" = "item")
	end_turn()

/battle_data/player/proc/try_switch()
	owner.visible_message("<b>\The [owner]</b> is trying to switch to another phantasm.")
	next_action = list("action" = "switch")
	end_turn()
