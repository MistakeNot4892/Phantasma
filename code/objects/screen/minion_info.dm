/obj/screen/data_panel
	name = "Minion Info"
	icon = 'icons/screen/infopanel.dmi'
	icon_state = "base"
	screen_loc = "7,3"

	var/data/minion/minion
	var/obj/screen/text/header_text
	var/obj/screen/text/hp_text
	var/obj/screen/text/xp_text

	var/obj/screen/text/atk_text
	var/obj/screen/text/def_text
	var/obj/screen/text/spatk_text
	var/obj/screen/text/spdef_text
	var/obj/screen/text/spd_text

/obj/screen/data_panel/New(var/data/minion/_minion)
	minion = _minion

	header_text = new("[minion.name]", _x=66, _y=355, _colour = DARK_BROWN)

	hp_text = new("HP",       _x=66, _y=339, _colour = DARK_RED)
	xp_text = new("XP",       _x=66, _y=295, _colour = DARK_RED)
	atk_text = new("HP",      _x=60, _y=100, _colour = DARK_RED)
	def_text = new("XP",      _x=160, _y=100, _colour = DARK_RED)
	spatk_text = new("SPATK", _x=60, _y=85, _colour = DARK_RED)
	spdef_text = new("SPDEF", _x=160, _y=85, _colour = DARK_RED)
	spd_text = new("SPD",     _x=110, _y=70, _colour = DARK_RED)

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
	I.pixel_y = 118
	images_to_add += I

	I = image(null)
	I.appearance = minion.health_bar
	I.pixel_x = 25
	I.pixel_y = 320
	images_to_add += I

	I = image(null)
	I.appearance = minion.xp_bar
	I.pixel_x = 35
	I.pixel_y = 310
	images_to_add += I

	var/i = 1
	var/stagger
	for(var/obj/screen/technique/T in minion.technique_panels)
		I = image(null)
		I.appearance = T
		I.pixel_x = 13
		I.pixel_y = 4
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

	I = image(null)
	atk_text.set_text("<b>ATK</b>:   [minion.data[MD_ATK]]",centered=0)
	I.appearance = atk_text
	images_to_add += I

	I = image(null)
	def_text.set_text("<b>DEF</b>:   [minion.data[MD_DEF]]",centered=0)
	I.appearance = def_text
	images_to_add += I

	I = image(null)
	spatk_text.set_text("<b>SPATK</b>: [minion.data[MD_SPATK]]",centered=0)
	I.appearance = spatk_text
	images_to_add += I

	I = image(null)
	spdef_text.set_text("<b>SPDEF</b>: [minion.data[MD_SPDEF]]",centered=0)
	I.appearance = spdef_text
	images_to_add += I

	I = image(null)
	spd_text.set_text("<b>SPD</b>: [minion.data[MD_SPEED]]",centered=0)
	I.appearance = spd_text
	images_to_add += I

	overlays += images_to_add
