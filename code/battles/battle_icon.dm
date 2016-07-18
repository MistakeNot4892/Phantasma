/image/battle
	plane = 10
	layer = 24

/obj/battle_icon
	icon = 'icons/screen/battle_underlay.dmi'
	screen_loc = "CENTER"
	plane = 9
	layer = 23

/obj/battle_icon/New()
	return

/obj/battle_icon/background
	name = "\improper FIGHT!"
	screen_loc = "CENTER"
	icon_state = "square"
	alpha = 0

/obj/battle_icon/background/New()
	var/matrix/M = matrix()
	M.Scale(25)
	transform = M

/obj/battle_icon/overlay
	var/image/sprite
	mouse_opacity = 0

/obj/battle_icon/overlay/New(var/image/_sprite)
	sprite = _sprite
	overlays += sprite

/obj/battle_icon/healthbar_mask
	icon = 'icons/screen/battle_hp_underlay.dmi'
	icon_state = "hp_over"
	maptext_width = 230
	alpha = 0

/obj/battle_icon/healthbar_bar
	icon = 'icons/screen/battle_hp_underlay.dmi'
	icon_state = "hp_bar"
	color = "#00FF00"
	alpha = 0

/obj/battle_icon/healthbar_bar/New()
	. = ..()
	var/matrix/M = matrix()
	M.Scale(0,1)
	M.Translate(-120,0)
	transform = M

/obj/battle_icon/healthbar
	name = "HP"
	screen_loc = "12,4"
	icon = 'icons/screen/battle_hp_underlay.dmi'
	icon_state = "hp_base"
	alpha = 0

	var/current_hp = 0
	var/last_raw_hp = 0
	var/battle_data/battle
	var/detailed = 1
	var/const/bar_size = 241

	var/obj/battle_icon/healthbar_bar/bar
	var/obj/battle_icon/healthbar_mask/mask

/obj/battle_icon/healthbar/enemy
	detailed = 0
	screen_loc = "2,11"

/obj/battle_icon/healthbar/New(var/battle_data/_battle)
	battle = _battle
	layer += 0.1

	bar = new(src)
	bar.layer = layer+0.1
	bar.screen_loc = screen_loc

	mask = new(src)
	mask.layer = layer+0.2
	mask.screen_loc = screen_loc

/obj/battle_icon/healthbar/proc/update()

	if(!battle)
		return

	mask.maptext = null
	var/minion/tracking = (detailed ? battle.minion : battle.opponent_minion)
	if(tracking)
		mask.maptext = "[tracking.name]"
		if(detailed)
			mask.maptext = "[mask.maptext] \[[tracking.data[MD_CHP]]/[tracking.data[MD_MHP]]\]"

	var/raw_hp_left = (tracking ? (tracking.data[MD_CHP]/tracking.data[MD_MHP]) : 0)

	if(raw_hp_left == last_raw_hp)
		return
	last_raw_hp = raw_hp_left

	if(raw_hp_left == 1)
		animate(bar, pixel_x = 0, transform = matrix(), color = "#00FF00", time = 8)
	else
		var/target_color
		if(raw_hp_left < 0.2)
			target_color = "#FF0000"
		else if(raw_hp_left < 0.7)
			target_color = "#FFFF00"
		else
			target_color = "#00FF00"
		var/matrix/M = matrix()
		M.Scale(raw_hp_left,1)
		M.Translate(-(round((bar_size-(bar_size * raw_hp_left))/2)),0)
		animate(bar, transform = M, color = target_color, time = 8)
