/mob/trainer/verb/switch_minion()
	if(frozen)
		return
	var/data/minion/switching = minions[1]
	minions -= switching
	minions += switching
	update_following_minion()

/mob/trainer/proc/update_following_minion(var/data/minion/new_minion)

	if(following && following.alpha == 255 && following.minion_data == new_minion)
		return

	if(!new_minion || (new_minion.status & STATUS_FAINTED))
		for(var/data/minion/temp in minions)
			if(temp.status & STATUS_FAINTED)
				continue
			new_minion = temp
			break

	if(following && following.alpha == 255 && following.minion_data == new_minion)
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

	var/data/selected/choice = new()
	var/list/selection_panel = list()
	var/i = 0
	for(var/data/minion/M in options)
		M.status_bar.update()
		var/obj/screen/select/MS = new(choice, M, M.status_bar)
		MS.screen_loc = "9,[13-i]"
		selection_panel += MS
		if(select_plane)
			MS.plane = select_plane
		if(select_layer)
			MS.layer = select_layer
		i++

	return select_from_visual_list(selection_panel, choice, select_plane, select_layer, can_cancel)

/mob/trainer/select_item_from_list(var/list/options = list(), var/select_plane = 99, var/select_layer = 99, var/can_cancel=1)

	if(!client)
		return pick(options)

	var/data/selected/choice = new()
	var/list/selection_panel = list()
	var/i = 0
	for(var/item_name in options)
		var/data/inventory_item/I = inventory[item_name]
		I.item_status.update(I)
		var/obj/screen/select/IS = new(choice, I, I.item_status)
		IS.screen_loc = "9,[13-i]"
		selection_panel += IS
		if(select_plane)
			IS.plane = select_plane
		if(select_layer)
			IS.layer = select_layer
		i++

	return select_from_visual_list(selection_panel, choice, select_plane, select_layer, can_cancel)

/mob/trainer/proc/select_from_visual_list(var/list/elements = list(), var/data/selected/choice, var/select_plane = 99, var/select_layer = 99, var/can_cancel = 1)

	if(!choice) choice = new()

	if(can_cancel)
		var/obj/screen/cancel_select/CMS = new(choice)
		CMS.screen_loc = "9,[13-elements.len]"
		if(select_plane)
			CMS.plane = select_plane
		if(select_layer)
			CMS.layer = select_layer
		elements += CMS

	if(client)
		client.screen += elements

	while(choice && client && !(choice.cancelled || choice.selection))
		sleep(1)

	if(client)
		client.screen -= elements

	for(var/thing in elements)
		qdel(thing)
	elements.Cut()

	var/selection = choice.selection
	qdel(choice)
	return (selection ? selection : null)
