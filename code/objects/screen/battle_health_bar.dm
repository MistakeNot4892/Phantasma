/obj/screen/battle_icon/healthbar_mask
	icon_state = "hp_over"
	maptext_width = 230
	alpha = 0
	maptext_x = 16
	maptext_y = 32
	layer = 3

/obj/screen/battle_icon/healthbar_bar
	icon_state = "hp_bar"
	color = "#00FF00"
	alpha = 0
	layer = 2

/obj/screen/battle_icon/healthbar_bar/New()
	. = ..()
	var/matrix/M = matrix()
	M.Scale(0,1)
	M.Translate(-120,0)
	transform = M

/obj/screen/battle_icon/healthbar
	name = "HP"
	screen_loc = "12,4"
	icon_state = "hp_base"
	alpha = 0
	layer = 1

	var/current_hp = 0
	var/last_raw_hp = 0
	var/data/battle_data/battle
	var/friendly = 1
	var/const/bar_size = 241
	var/obj/screen/battle_icon/healthbar_bar/bar
	var/obj/screen/battle_icon/healthbar_mask/mask
	var/screen_loc_x = 12
	var/screen_loc_y = 5

/obj/screen/battle_icon/healthbar/destroy()
	battle = null
	qdel(bar)
	bar = null
	qdel(mask)
	mask = null
	return ..()

/obj/screen/battle_icon/healthbar/enemy
	friendly = 0
	screen_loc_x = 2
	screen_loc_y = 14

/obj/screen/battle_icon/healthbar/New(var/data/battle_data/_battle, var/count=0)

	battle = _battle
	layer += 0.1

	if(friendly)
		screen_loc = "[screen_loc_x],[screen_loc_y+count]"
	else
		screen_loc = "[screen_loc_x],[screen_loc_y-count]"

	bar = new(src)
	bar.screen_loc = screen_loc

	mask = new(src)
	mask.screen_loc = screen_loc

/obj/screen/battle_icon/healthbar/proc/update()

	if(!battle)
		return

	mask.maptext = null
	var/data/minion/tracking = battle.minion

	if(tracking)
		if(friendly)
			mask.maptext = "<span style = 'font-family:courier'><font color = '#cbdbfc'><b>[tracking.name] \[[tracking.data[MD_CHP]]/[tracking.data[MD_MHP]]\]</b></font></span>"
		else
			mask.maptext = "<span style = 'font-family:courier'><font color = '#cbdbfc'><b>[tracking.name]</b></font></span>"


	var/raw_hp_left = (tracking ? (tracking.data[MD_CHP]/tracking.data[MD_MHP]) : 0)

	if(raw_hp_left == last_raw_hp)
		return
	last_raw_hp = raw_hp_left

	if(raw_hp_left == 1)
		animate(bar, pixel_x = 0, transform = matrix(), color = "#99E550", time = 8)
	else
		var/target_color
		if(raw_hp_left < 0.2)
			target_color = "#AC3232"
		else if(raw_hp_left < 0.7)
			target_color = "#FBF236"
		else
			target_color = "#99E550"
		var/matrix/M = matrix()
		M.Scale(raw_hp_left,1)
		M.Translate(-(round((bar_size-(bar_size * raw_hp_left))/2)),0)
		animate(bar, transform = M, color = target_color, time = 8)
