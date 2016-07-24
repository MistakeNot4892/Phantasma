/obj/screen/statbar
	name = "HP"
	icon = 'icons/screen/statbar_big.dmi'
	icon_state = "base"

	var/image/bar
	var/data/minion/tracking
	var/last_raw
	var/bar_size = 240
	var/default_color = PALE_GREEN

/obj/screen/statbar/proc/get_remaining()
	return tracking.data[MD_CHP]/tracking.data[MD_MHP]

/obj/screen/statbar/New(var/data/minion/_tracking)
	tracking = _tracking
	bar = image(icon, "bar")
	bar.layer = layer+0.1
	overlays += bar
	var/image/mask = image(icon, "over")
	mask.layer = layer+0.2
	overlays += mask
	update()

/obj/screen/statbar/proc/get_bar_color(var/raw_left)
	if(raw_left < 0.2)
		return DARK_RED
	else if(raw_left < 0.7)
		return BRIGHT_YELLOW
	return PALE_GREEN

/obj/screen/statbar/proc/update()

	var/raw_left = get_remaining()

	if(!isnull(last_raw) && raw_left == last_raw)
		return
	last_raw = raw_left

	overlays -= bar
	if(raw_left == 1)
		animate(bar, pixel_x = 0, transform = matrix(), color = default_color, time = 8)
	else
		var/target_color = get_bar_color(raw_left)
		var/matrix/M = matrix()
		M.Scale(raw_left,1)
		M.Translate(-(round((bar_size-(bar_size * raw_left))/2)),0)
		animate(bar, transform = M, color = target_color, time = 8)
	overlays += bar

/obj/screen/statbar/experience
	name = "XP"
	default_color = PALE_BLUE
	icon = 'icons/screen/statbar.dmi'
	bar_size = 220

/obj/screen/statbar/experience/get_remaining()
	var/last_xp = get_xp_threshold_for(tracking.data[MD_LVL]-1)
	return ((tracking.data[MD_EXP]-last_xp)/(get_xp_threshold_for(tracking.data[MD_LVL])-last_xp))

/obj/screen/statbar/experience/get_bar_color()
	return default_color
