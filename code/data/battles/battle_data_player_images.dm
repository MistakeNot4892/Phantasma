#define DEFAULT_ALLY_AXIS -150
#define DEFAULT_OPPONENT_AXIS 16

/data/battle_data/player
	var/image/battle/backlight/minion_backlight
	var/image/battle/backlight/opponent_backlight
	var/list/all_images =              list()
	var/list/minion_images =           list()
	var/list/opponent_images =         list()
	var/list/trainer_images =          list()
	var/list/opponent_trainer_images = list()
	var/opponents_offset = 0
	var/allies_offset = 0

/data/battle_data/player/proc/initialize_images()
	// Create images!
	for(var/data/battle_data/ally in allies)
		var/image/I = new /image/battle/entity(loc = owner, icon = 'icons/battle/icons_rear.dmi',  icon_state = initial(ally.owner.icon_state))
		trainer_images["\ref[ally]"] = I
		I.layer = 20 + ally.team_position
		I.alpha = 0
		I.pixel_x =  (-300-((allies_offset*(allies.len)))/2)+(allies_offset*ally.team_position)
		I.pixel_y =  DEFAULT_ALLY_AXIS
		all_images += I
	for(var/data/battle_data/opponent in opponents)
		var/image/I = new /image/battle/entity(loc = owner, icon = 'icons/battle/icons_front.dmi',  icon_state = initial(opponent.owner.icon_state))
		I.layer = 10 + opponent.team_position
		trainer_images["\ref[opponent]"] = I
		I.alpha = 0
		I.pixel_x = (50-((opponents_offset*(opponents.len)))/2)+(opponents_offset*opponent.team_position)
		I.pixel_y = DEFAULT_OPPONENT_AXIS
		all_images += I

	minion_backlight = new /image/battle/backlight(loc = owner, icon = 'icons/screen/battle_environments.dmi',  icon_state = battle.environment_type)
	minion_backlight.pixel_x = -300
	minion_backlight.pixel_y = DEFAULT_ALLY_AXIS-35
	minion_backlight.alpha = 0
	all_images += minion_backlight

	opponent_backlight = new /image/battle/backlight(loc = owner, icon = 'icons/screen/battle_environments.dmi',  icon_state = battle.environment_type)
	opponent_backlight.pixel_x = 20
	opponent_backlight.pixel_y = DEFAULT_OPPONENT_AXIS-35
	opponent_backlight.alpha = 0
	var/matrix/M = matrix()
	M.Scale(0.75)
	opponent_backlight.transform = M
	all_images += opponent_backlight

	// Make sure all our images are in place.
	update_minion_images(1,1)

/data/battle_data/player/proc/update_images_with(var/list/update_data, var/are_opponents)

	var/default_x = -220
	var/default_y = DEFAULT_ALLY_AXIS
	var/use_icon = 'icons/battle/icons_rear.dmi'
	var/use_offset = allies_offset

	if(are_opponents)
		default_x = 40
		default_y = DEFAULT_OPPONENT_AXIS
		use_icon = 'icons/battle/icons_front.dmi'
		use_offset = opponents_offset

	for(var/data/battle_data/player in update_data)

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
		var/image/I = new /image/battle/entity(loc = owner, icon = use_icon,  icon_state = (player.minion ? player.minion.template.icon_state : ""))
		if(!are_opponents)
			I.layer += 0.1
		I.alpha = last_alpha
		I.pixel_x = last_pixel_x
		I.pixel_y = last_pixel_y
		minion_images["\ref[player]"] = I
		all_images += I
		client.images += I

/data/battle_data/player/update_minion_image(var/data/battle_data/player)
	update_images_with(list(player), (player in opponents))

/data/battle_data/player/update_minion_images(var/update_minon, var/update_opponent)
	if(!owner || !client)
		return
	if(update_minon)
		update_images_with(allies)
	if(update_opponent)
		update_images_with(opponents, 1)

/data/battle_data/player/do_item_animation(var/data/item/template, var/data/battle_data/target)
	var/image/I = minion_images["\ref[target]"]
	if(istype(I))
		template.do_battle_animation(I)
	return
