/obj/screen/minion_stat
	name = "Minion Status"
	icon = 'icons/screen/minion_status.dmi'
	icon_state = "base"
	layer = 2
	maptext_x = 13
	maptext_y = 18
	maptext_width = 110
	var/data/minion/minion

/obj/screen/minion_stat/clicked(var/client/clicker)
	if(!owner.client || clicker != owner.client)
		return

	if(!minion)
		alpha = 0
		invisibility = 100
		return
	alpha = 255
	invisibility = 0

	var/mob/trainer/T = owner
	if(T.viewing_minion == minion)
		T.client.screen -= minion.get_info_panel()
		T.viewing_minion = null
		color = "#FFFFFF"
		return

	for(var/obj/screen/minion_stat/MS in T.minion_status)
		MS.color = "#FFFFFF"

	if(T.viewing_minion)
		T.client.screen -= T.viewing_minion.get_info_panel()
		T.viewing_minion = null

	color = "#AAAAAA"
	T.viewing_minion = minion
	T.client.screen += T.viewing_minion.get_info_panel()

// Allow drag and drop rearranging to change the order of your minions.
/obj/screen/minion_stat/MouseDrop(var/over_object)

	var/obj/screen/minion_stat/MS = over_object
	var/mob/trainer/T = owner
	if(istype(MS) && istype(T))
		if(MS.alpha == 0)
			return
		// Update screen loc.
		var/last_screen_loc = screen_loc
		screen_loc = MS.screen_loc
		MS.screen_loc = last_screen_loc

		// Update status object order.
		var/theirpos = T.minion_status.Find(MS)
		var/mypos = T.minion_status.Find(src)
		T.minion_status -= src
		T.minion_status.Insert(theirpos,src)
		T.minion_status -= MS
		T.minion_status.Insert(mypos,MS)

		// Update minion order.
		T.minions.Cut()
		for(var/obj/screen/minion_stat/status in T.minion_status)
			if(status.minion)
				T.minions += status.minion
		T.update_following_minion()
		T.update_minion_status()

	return ..()

/obj/screen/minion_toggle
	name = "Toggle Minion Display"
	icon = 'icons/screen/minion_status.dmi'
	icon_state = "toggle_show"
	screen_loc = "17,8"

/obj/screen/minion_toggle/clicked(var/client/clicker)
	var/mob/trainer/T = owner
	if(istype(T) && owner.client == T.client)
		T.show_minions = !T.show_minions
		T.update_minion_status()
		if(T.show_minions)
			T.client.screen += T.minion_status
			icon_state = "toggle_hide"
		else
			T.client.screen -= T.minion_status
			icon_state = "toggle_show"
			if(T.viewing_minion)
				T.client.screen -= T.viewing_minion.get_info_panel()
				T.viewing_minion = null

/obj/screen/minion_stat/New(var/_owner, var/data/minion/_minion)
	..(_owner)
	if(_minion)
		set_minion(_minion)
	else
		alpha = 0
		invisibility = 100

/obj/screen/minion_stat/proc/set_minion(var/data/minion/_minion)
	minion = _minion
	update_status()

/obj/screen/minion_stat/proc/update_status()
	overlays.Cut()
	maptext = null
	if(!minion)
		return

	if(minion)
		alpha = 255
		invisibility = 0
	else
		alpha = 0
		invisibility = 100

	var/image/bar = image(icon, "statbar")
	bar.plane = plane
	var/minion_hp = minion.data[MD_CHP]/minion.data[MD_MHP]
	var/matrix/M = matrix()
	var/mob/trainer/T = owner

	M.Scale(minion_hp,1)
	M.Translate(-(round((64-(64 * minion_hp))/2)),0)
	bar.transform = M
	if(minion_hp < 0.2)
		bar.color = "#AC3232"
	else if(minion_hp < 0.7)
		bar.color = "#FBF236"
	else
		bar.color = "#99E550"
	overlays += bar
	overlays += "overlay"
	var/image/I = image(icon, "gem")
	I.plane = plane
	I.color = minion.template.gem_colour
	overlays += I
	maptext = "<span style = 'font-family:courier'><font color = '#cbdbfc'><b>[T.minions.Find(minion)].</b>[minion.name]</span></font>"
