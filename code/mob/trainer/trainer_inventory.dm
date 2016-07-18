/mob/trainer
	var/list/inventory_contents = list()
	var/list/inventory_data = list()
	var/tmp/max_items = 100

/mob/trainer/verb/check_inventory()
	src << "You are carrying [inventory_contents.len] item\s."
	for(var/list/inventory_item in inventory_data)
		src << "[inventory_item["count"]] x [inventory_item["name"]]: [inventory_item["desc"]]"

/mob/trainer/proc/add_item(var/obj/item/item)
	if(!item)
		return
	if(inventory_contents.len > max_items)
		src << "You are carrying too much to collect <b>\the [item]</b>."
		return

	item.move_to(src)
	inventory_contents += item
	var/found
	for(var/list/thing in inventory_data)
		if(thing["name"] == item.name && thing["desc"] == item.desc)
			thing["count"]++
			found = 1
			break
	if(!found)
		inventory_data += list(list("name" = item.name, "desc" = item.desc, "count" = 1))
	visible_message("<b>\The [src]</b> picked up \the [item].")

/mob/trainer/proc/remove_item(var/item_path, var/amt=1)
	var/obj/item/I = locate(item_path) in inventory_contents
	if(!istype(I))
		return

	inventory_contents -= I

	for(var/list/thing in inventory_data)
		if(thing["name"] == I.name && thing["desc"] == I.desc)
			thing["count"] -= amt
			if(thing["count"] <= 0)
				inventory_data -= thing
			break
		qdel(I)
