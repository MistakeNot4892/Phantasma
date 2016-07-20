/obj/item
	name = "generic item"
	density = 0
	icon = 'icons/overworld/item.dmi'
	icon_state = ""
	plane = ITEM_PLANE

	var/item_path = /data/item

/obj/item/clicked(var/client/clicker)
	var/mob/trainer/T = clicker.mob
	if(istype(T))
		if(get_dist(T, src)>1)
			T << "You are too far away."
			return
		if(T.add_item(item_path))
			visible_message("<b>\The [T]</b> picks up <b>\the [src]</b>.")
			qdel(src)
		else
			T << "You are carrying too much already!"
	return
