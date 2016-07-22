/obj/item
	name = "generic item"
	density = 0
	icon = 'icons/overworld/item.dmi'
	icon_state = ""
	layer = ITEM_LAYER

	var/item_path = /data/item

/obj/item/clicked(var/client/clicker)
	var/mob/trainer/T = clicker.mob
	if(istype(T))
		if(get_dist(T, src)>1)
			T.notify("You are too far away.")
			return
		if(T.add_item(item_path))
			notify_nearby("<b>\The [T]</b> picks up <b>\the [src]</b>.")
			qdel(src)
		else
			T.notify("You are carrying too much already!")
	return
