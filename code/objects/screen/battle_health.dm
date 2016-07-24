/obj/screen/battle_icon/health
	name = "Vital Statistics"
	icon = null
	plane = 95
	maptext_height = 50
	maptext_width = 500
	maptext_x = 10
	maptext_y = 18

	var/data/battle_data/tracking

/obj/screen/battle_icon/health/New(var/data/battle_data/_battle, var/data/battle_data/_tracking, var/_x = 0, var/_y = 0)
	..(_battle)
	tracking = _tracking
	pixel_x = _x
	pixel_y = _y

/obj/screen/battle_icon/health/proc/get_image()
	update()
	maptext = "<b><font color = [PALE_BLUE]>[maptext]</font></b>"

	var/image/image_to_add
	if(!tracking.minion)
		image_to_add = image('icons/screen/statbar_big.dmi', "empty")
	else
		image_to_add = image(null)
		image_to_add.appearance = tracking.minion.health_bar
		image_to_add.plane = plane

	var/image/I = image(loc=battle.owner)
	I.appearance = src
	I.plane = plane
	I.overlays += image_to_add
	I.pixel_x = pixel_x
	I.pixel_y = pixel_y

	return I

/obj/screen/battle_icon/health/proc/update()
	alpha = 255
	invisibility = 0
	maptext = initial(maptext)
	if(battle && tracking.minion)
		tracking.minion.health_bar.update()
		tracking.minion.xp_bar.update()
		return 1

/obj/screen/battle_icon/health/ally/update()
	if(..())
		maptext = "[tracking.minion.name] [tracking.minion.data[MD_CHP]]/[tracking.minion.data[MD_MHP]]HP       LV.[tracking.minion.data[MD_LVL]]"
		return 1
	return 0

/obj/screen/battle_icon/health/ally/self/get_image()
	var/image/temp = ..()
	var/image/I = image(null)
	I.appearance = tracking.minion.xp_bar
	I.pixel_y = -8
	I.pixel_x += 10
	I.plane = plane
	temp.overlays += I
	return temp

/obj/screen/battle_icon/health/enemy/update()
	if(..())
		maptext = "[tracking.minion.name]"
		return 1
	return 0
