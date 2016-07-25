/obj/screen/battle_icon/health
	name = "Vital Statistics"
	icon = null
	plane = 95
	maptext_height = 50
	maptext_width = 500
	maptext_x = 10
	maptext_y = 18

	var/obj/screen/text/level_display
	var/obj/screen/text/health_display
	var/data/battle_data/tracking

/obj/screen/battle_icon/health/New(var/data/battle_data/_battle, var/data/battle_data/_tracking, var/_x = 0, var/_y = 0)
	..(_battle)
	tracking = _tracking
	pixel_x = _x
	pixel_y = _y
	level_display = new("LV.", _x=140, _y=maptext_y, _colour = PALE_BROWN)

/obj/screen/battle_icon/health/proc/get_image()
	update()
	maptext = "<b><font color = [PALE_BLUE]>[maptext]</font></b>"

	var/list/images_to_add = list()
	if(!tracking.minion)
		images_to_add += image('icons/screen/statbar_big.dmi', "empty")
	else
		var/image/temp = image(null)
		temp.appearance = tracking.minion.health_bar
		temp.plane = plane
		images_to_add += temp

		temp = image(null)
		temp.appearance = level_display
		temp.plane = plane
		images_to_add += temp

		if(health_display)
			temp = image(null)
			temp.appearance = health_display
			temp.plane = plane
			images_to_add += temp

	var/image/I = image(loc=battle.owner)
	I.appearance = src
	I.plane = plane
	I.overlays += images_to_add
	I.pixel_x = pixel_x
	I.pixel_y = pixel_y

	return I

/obj/screen/battle_icon/health/proc/update()
	alpha = 255
	invisibility = 0
	maptext = initial(maptext)
	if(level_display)
		level_display.set_text("")

	if(battle && tracking.minion)
		tracking.minion.health_bar.update()
		tracking.minion.xp_bar.update()
		maptext = "[tracking.minion.name]"
		if(level_display)
			level_display.set_text("<b>LV.[tracking.minion.data[MD_LVL]]</b>")
		return 1

/obj/screen/battle_icon/health/ally/New()
	health_display = new("HP.", _x=70, _y=maptext_y, _colour = PALE_BLUE)
	..()

/obj/screen/battle_icon/health/ally/update()
	if(..())
		if(tracking.minion && tracking.minion)
			if(health_display) health_display.set_text("<b>[tracking.minion.data[MD_CHP]]/[tracking.minion.data[MD_MHP]]</b> HP")
		else
			maptext = null
			if(health_display) health_display.set_text("")
		return 1
	return 0

/obj/screen/battle_icon/health/ally/self/get_image()
	var/image/temp = ..()
	var/image/image_to_add
	if(!tracking.minion)
		image_to_add = image('icons/screen/statbar.dmi', "empty")
	else
		image_to_add = image(null)
		image_to_add.appearance = tracking.minion.xp_bar

	image_to_add.plane = plane
	image_to_add.pixel_y = -8
	image_to_add.pixel_x += 10
	temp.overlays += image_to_add
	return temp
