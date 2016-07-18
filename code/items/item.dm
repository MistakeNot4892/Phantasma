/obj/item
	name = "generic item"
	density = 0
	icon = 'icons/overworld/item.dmi'
	icon_state = ""
	layer = MOB_LAYER-0.1

/obj/item/clicked(var/client/clicker)
	var/mob/trainer/T = clicker.mob
	if(istype(T))
		T.add_item(src)
