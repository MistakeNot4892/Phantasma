/obj/item
	name = "generic item"
	density = 0
	icon = 'icons/overworld/item.dmi'
	icon_state = ""
	layer = MOB_LAYER-0.1
	var/item_path = /data/item

/obj/item/clicked(var/client/clicker)
	var/mob/trainer/T = clicker.mob
	if(istype(T))
		if(T.add_item(item_path))
			visible_message("<b>\The [T]</b> picks up <b>\the [src]</b>.")
			qdel(src)
		else
			T << "You are carrying too much already!"
	return
