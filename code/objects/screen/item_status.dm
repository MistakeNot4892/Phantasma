/obj/screen/item_status
	name = "Item"
	icon = 'icons/screen/selection.dmi'
	icon_state = "base"
	maptext_width = 300
	maptext_x = 36
	maptext_y = 10

/obj/screen/item_status/New()
	..()
	clear()

/obj/screen/item_status/proc/update(var/data/inventory_item/item)
	if(!item || !item.item_template)
		clear()
		return
	maptext = "<b>[item.item_template.name]</b> x [item.count]"
	invisibility = 0
	overlays.Cut()
	overlays += image('icons/screen/inv_items.dmi', item.item_template.icon_state)

/obj/screen/item_status/proc/clear()
	maptext = null
	invisibility = 100

/obj/screen/item_status/destroy()
	return ..()

/obj/screen/item_status_arrow
	name = "Up"
	icon = 'icons/screen/selection.dmi'
	icon_state = "arrow_up"
	screen_loc = "1,15"

/obj/screen/item_status_arrow/clicked(var/client/clicker)
	color = PALE_GREY
	spawn(3)
		color = WHITE
	var/mob/trainer/T = clicker.mob
	if(istype(T))
		adjust_inv_index(T)
		T.update_inventory_status()

/obj/screen/item_status_arrow/proc/adjust_inv_index(var/mob/trainer/trainer)
	trainer.inv_index--

/obj/screen/item_status_arrow/down
	name = "Down"
	icon_state = "arrow_down"
	screen_loc = "1,8"

/obj/screen/item_status_arrow/down/adjust_inv_index(var/mob/trainer/trainer)
	trainer.inv_index++

/obj/screen/inventory_toggle
	name = "Toggle Inventory Display"
	icon = 'icons/screen/selection_bkg.dmi'
	icon_state = "inv_retracted"
	screen_loc = "1,8"

/obj/screen/inventory_toggle/clicked(var/client/clicker)
	var/mob/trainer/T = owner
	if(istype(T) && owner.client == T.client)
		T.show_inventory = !T.show_inventory
		T.update_inventory_status()
		if(T.show_inventory)
			T.client.screen += T.inventory_panels
			icon_state = "inv"
		else
			reset()

/obj/screen/inventory_toggle/proc/reset()
	var/mob/trainer/T = owner
	if(istype(T))
		T.show_inventory = 0
		for(var/obj/screen/item_panel/MS in T.inventory_panels)
			MS.color = WHITE
		if(T.client)
			T.client.screen -= T.inventory_panels
		icon_state = "inv_retracted"
