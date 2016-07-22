/obj/screen/battle_icon/statbar
	name = "HP"
	screen_loc = "12,4"
	icon_state = "hp_base"
	alpha = 0

	var/icon_prefix = "hp"
	var/last_raw = 0
	var/data/battle_data/battle
	var/friendly = 1
	var/bar_size = 252
	var/obj/screen/battle_icon/statbar_bar/bar
	var/mask_type = /obj/screen/battle_icon/statbar_mask
	var/obj/screen/battle_icon/statbar_mask/mask
	var/screen_loc_x = 12
	var/screen_loc_y = 5
	var/default_color = "#99E550"

/obj/screen/battle_icon/statbar/proc/update_maptext(var/data/minion/tracking)
	mask.maptext = null
	if(tracking)
		if(friendly)
			mask.maptext = "<span style = 'font-family:courier'><font color = '[OFF_WHITE]'><b>[tracking.name] \[[tracking.data[MD_CHP]]/[tracking.data[MD_MHP]]\]</b></font></span>"
		else
			mask.maptext = "<span style = 'font-family:courier'><font color = '[OFF_WHITE]'><b>[tracking.name]</b></font></span>"

/obj/screen/battle_icon/statbar/proc/get_remaining(var/data/minion/tracking)
	return (tracking ? (tracking.data[MD_CHP]/tracking.data[MD_MHP]) : 0)

/obj/screen/battle_icon/statbar/destroy()
	battle = null
	qdel(bar)
	bar = null
	qdel(mask)
	mask = null
	return ..()

/obj/screen/battle_icon/statbar/enemy
	friendly = 0
	screen_loc_x = 2
	screen_loc_y = 14

/obj/screen/battle_icon/statbar/New(var/data/battle_data/_battle, var/count=0)

	battle = _battle

	icon_state = "[icon_prefix]_base"
	if(friendly)
		screen_loc = "[screen_loc_x],[screen_loc_y+count]"
	else
		screen_loc = "[screen_loc_x],[screen_loc_y-count]"

	bar = new(src)
	bar.layer = layer+0.1
	bar.screen_loc = screen_loc
	bar.icon_state = "[icon_prefix]_bar"
	bar.name = name
	bar.color = default_color

	mask = new mask_type(src)
	mask.layer = layer+0.2
	mask.screen_loc = screen_loc
	mask.icon_state = "[icon_prefix]_over"
	mask.name = name

/obj/screen/battle_icon/statbar/proc/get_bar_color(var/raw_left)
	if(raw_left < 0.2)
		return "#AC3232"
	else if(raw_left < 0.7)
		return "#FBF236"
	return "#99E550"

/obj/screen/battle_icon/statbar/proc/update()

	if(!battle)
		return

	var/data/minion/tracking = battle.minion
	update_maptext(tracking)

	var/raw_left = get_remaining(tracking)

	if(raw_left == last_raw)
		return
	last_raw = raw_left

	if(raw_left == 1)
		animate(bar, pixel_x = 0, transform = matrix(), color = default_color, time = 8)
	else
		var/target_color = get_bar_color(raw_left)
		var/matrix/M = matrix()
		M.Scale(raw_left,1)
		M.Translate(-(round((bar_size-(bar_size * raw_left))/2)),0)
		animate(bar, transform = M, color = target_color, time = 8)

/obj/screen/battle_icon/statbar/xp
	name = "XP"
	icon_prefix = "xp"
	mask_type = /obj/screen/battle_icon/statbar_mask/xp
	bar_size = 241
	default_color = "#3F3F74"

/obj/screen/battle_icon/statbar/xp/get_remaining(var/data/minion/tracking)
	return (tracking ? (tracking.data[MD_EXP]/get_amount_to_next_level(tracking.data[MD_LVL])) : 0)

/obj/screen/battle_icon/statbar/xp/update_maptext(var/data/minion/tracking)
	if(tracking)
		mask.maptext = "<span style = 'font-family:courier'><font color = '[OFF_WHITE]'><b>LV.[tracking.data[MD_LVL]]</b></font></span>"
	else
		mask.maptext = null

/obj/screen/battle_icon/statbar/xp/get_bar_color(var/raw_left)
	return default_color

/obj/screen/battle_icon/statbar_mask
	icon_state = "hp_over"
	maptext_width = 230
	alpha = 0
	maptext_x = 12
	maptext_y = 36

/obj/screen/battle_icon/statbar_mask/xp
	maptext_x = 210
	maptext_y = 36
	maptext_width = 50

/obj/screen/battle_icon/statbar_bar
	icon_state = "hp_bar"
	alpha = 0

/obj/screen/battle_icon/statbar_bar/New()
	. = ..()
	var/matrix/M = matrix()
	M.Scale(0,1)
	M.Translate(-120,0)
	transform = M