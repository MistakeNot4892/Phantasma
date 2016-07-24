/mob/trainer/verb/switch_minion()
	if(frozen)
		return
	var/data/minion/switching = minions[1]
	minions -= switching
	minions += switching
	update_following_minion()

/mob/trainer/proc/update_following_minion(var/data/minion/new_minion)

	if(following && following.minion_data == new_minion)
		return

	if(!new_minion || (new_minion.status & STATUS_FAINTED))
		for(var/data/minion/temp in minions)
			if(temp.status & STATUS_FAINTED)
				continue
			new_minion = temp
			break

	if(following && following.minion_data == new_minion)
		return

	if(!new_minion)
		if(following)
			spawn(0)
				animate(following, alpha=0, time = 3)
				sleep(3)
				qdel(following)
		return

	if(!following)
		following = new(get_turf(src), new_minion)
		following.density = 0
	else
		following.change_to_minion(new_minion)

/mob/trainer/select_minion_from_list(var/list/options = list(), var/select_plane = 99, var/select_layer = 99, var/can_cancel=1)

	if(!client)
		return pick(options)

	var/list/selection_panel = list()
	var/data/selected_minion/choice = new()

	var/i = 0
	for(var/data/minion/M in options)
		var/obj/screen/minion_select/MS = new(M, choice)
		MS.screen_loc = "9,[13-i]"
		selection_panel += MS
		if(select_plane)
			MS.plane = select_plane
		if(select_layer)
			MS.layer = select_layer
		i++

	if(can_cancel)
		var/obj/screen/cancel_minion_select/CMS = new(choice)
		CMS.screen_loc = "9,[13-i]"
		if(select_plane)
			CMS.plane = select_plane
		if(select_layer)
			CMS.layer = select_layer
		selection_panel += CMS

	if(client)
		client.screen += selection_panel

	while(choice && client && !(choice.cancelled || choice.selection))
		sleep(1)

	if(client)
		client.screen -= selection_panel

	for(var/thing in selection_panel)
		qdel(thing)
	selection_panel.Cut()

	var/data/minion/selection = choice.selection
	qdel(choice)
	return (choice ? selection : null)