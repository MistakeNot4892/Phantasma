var/list/items_by_path = list()

/proc/get_item_by_path(var/itempath)
	if(!items_by_path[itempath])
		items_by_path[itempath] = new itempath
	return items_by_path[itempath]

/data/item
	var/name = "item"
	var/desc = "An item."
	var/battle_use_delay = 25
	var/key_item
	var/can_use_battle
	var/can_use_overmap
	var/hostile

/data/item/proc/do_battle_animation(var/image/target)
	set waitfor=0
	set background =1
	return target

/data/item/proc/apply(var/minion/target)
	return
