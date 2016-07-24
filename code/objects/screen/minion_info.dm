/obj/screen/data_panel
	name = "Minion Info"
	icon = 'icons/screen/infopanel.dmi'
	icon_state = "base"
	screen_loc = "7,4"

	var/data/minion/minion
	var/obj/screen/text/header_text
	var/obj/screen/text/hp_text
	var/obj/screen/text/xp_text

/obj/screen/data_panel/New(var/data/minion/_minion)
	minion = _minion
	header_text = new("[minion.name]", _x=66, _y=323, _colour = DARK_BROWN)
	hp_text = new("HP", _x=66, _y=307, _colour = DARK_RED)
	xp_text = new("XP", _x=66, _y=263, _colour = DARK_RED)
	update()
	var/matrix/M = matrix()
	M.Translate(-16,0)
	transform = M

/obj/screen/data_panel/proc/update()
	maptext = null
	if(!minion)
		return

	overlays.Cut()
	var/list/images_to_add = list()

	minion.health_bar.update()
	minion.xp_bar.update()

	var/image/I = image('icons/battle/icons_front.dmi', minion.template.icon_state)
	I.pixel_x = 16
	I.pixel_y = 90
	images_to_add += I

	I = image(null)
	I.appearance = minion.health_bar
	I.pixel_x = 25
	I.pixel_y = 288
	images_to_add += I

	I = image(null)
	I.appearance = minion.xp_bar
	I.pixel_x = 35
	I.pixel_y = 278
	images_to_add += I

	var/i = 1
	var/stagger
	for(var/obj/screen/technique/T in minion.technique_panels)
		I = image(null)
		I.appearance = T
		I.pixel_x = 13
		I.pixel_y = 8
		if(i>2)
			I.pixel_y += 30
		if(stagger)
			stagger = 0
			I.pixel_x += 136
		else
			stagger = 1
		images_to_add += I
		i++

	I = image(null)
	header_text.set_text("<b>[minion.name]</b>")
	I.appearance = header_text
	images_to_add += I

	I = image(null)
	hp_text.set_text("[minion.data[MD_CHP]]/[minion.data[MD_MHP]] <b>HP</b>")
	I.appearance = hp_text
	images_to_add += I

	I = image(null)
	xp_text.set_text("<b>LV.</b>[minion.data[MD_LVL]], [minion.data[MD_EXP]]/[get_xp_threshold_for(minion.data[MD_LVL])] <b>XP</b>")
	I.appearance = xp_text
	images_to_add += I

	overlays += images_to_add

