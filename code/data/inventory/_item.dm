/data/item
	var/name = "item"
	var/desc = "An item."
	var/battle_use_delay = 25
	var/key_item
	var/can_use_battle
	var/can_use_overmap
	var/hostile
	var/icon_state

/data/item/proc/do_battle_animation(var/image/target)
	set waitfor=0
	set background =1
	return target

/data/item/proc/apply(var/data/minion/target)
	return
