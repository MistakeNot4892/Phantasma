/obj/screen/minion_panel
	name = "Minion Status"
	icon = 'icons/screen/selection.dmi'
	icon_state = "base"
	var/data/minion/minion

/obj/screen/minion_panel/New(var/_owner, var/data/minion/_minion)
	..(_owner)
	if(_minion)
		set_minion(_minion)
	else
		alpha = 0
		invisibility = 100

/obj/screen/minion_panel/proc/set_minion(var/data/minion/_minion)
	minion = _minion
	update()

/obj/screen/minion_panel/proc/update()

	if(minion)
		alpha = 255
		invisibility = 0
	else
		alpha = 0
		invisibility = 100
		return

	minion.status_bar.update()
	appearance = minion.status_bar

/obj/screen/minion_panel/clicked(var/client/clicker)

	if(!owner.client || clicker != owner.client)
		return

	update()

	var/mob/trainer/T = owner
	if(T.viewing_minion == minion)
		T.client.screen -= minion.get_info_panel()
		T.viewing_minion = null
		color = WHITE
		return

	for(var/obj/screen/minion_panel/MS in T.minion_status_panels)
		MS.color = WHITE

	if(T.viewing_minion)
		T.client.screen -= T.viewing_minion.get_info_panel()
		T.viewing_minion = null

	color = PALE_GREY
	T.viewing_minion = minion
	T.client.screen += T.viewing_minion.get_info_panel()

// Allow drag and drop rearranging to change the order of your minions.
/obj/screen/minion_panel/MouseDrop(var/over_object)

	var/obj/screen/minion_panel/MS = over_object
	var/mob/trainer/T = owner
	if(istype(MS) && istype(T))
		if(MS.alpha == 0)
			return
		// Update screen loc.
		var/last_screen_loc = screen_loc
		screen_loc = MS.screen_loc
		MS.screen_loc = last_screen_loc

		// Update status object order.
		var/theirpos = T.minion_status_panels.Find(MS)
		var/mypos = T.minion_status_panels.Find(src)
		T.minion_status_panels -= src
		T.minion_status_panels.Insert(theirpos,src)
		T.minion_status_panels -= MS
		T.minion_status_panels.Insert(mypos,MS)

		// Update minion order.
		T.minions.Cut()
		for(var/obj/screen/minion_panel/status in T.minion_status_panels)
			if(status.minion)
				T.minions += status.minion
		T.update_following_minion()
		T.update_minion_status()

	return ..()

/obj/screen/minion_toggle
	name = "Toggle Minion Display"
	icon = 'icons/screen/selection_bkg.dmi'
	icon_state = "min_retracted"
	screen_loc = "16,8"

/obj/screen/minion_toggle/clicked(var/client/clicker)
	var/mob/trainer/T = owner
	if(istype(T) && owner.client == T.client)
		T.show_minions = !T.show_minions
		T.update_minion_status()
		if(T.show_minions)
			T.client.screen += T.minion_status_panels
			icon_state = "min"
		else
			reset()

/obj/screen/minion_toggle/proc/reset()
	var/mob/trainer/T = owner
	if(istype(T))
		T.show_minions = 0
		for(var/obj/screen/minion_panel/MS in T.minion_status_panels)
			MS.color = WHITE
		if(T.client)
			T.client.screen -= T.minion_status_panels
		icon_state = "min_retracted"
		if(T.viewing_minion)
			if(T.client)
				T.client.screen -= T.viewing_minion.get_info_panel()
			T.viewing_minion = null