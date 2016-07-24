/mob/trainer/proc/add_item(var/item_path, var/item_amount = 1)
	if((held_items + item_amount) > max_items)
		return 0
	var/data/item/item_data = get_unique_data_by_path(item_path)
	if(!inventory[item_data.name])
		inventory[item_data.name] = new /data/inventory_item(item_path, src)
	var/data/inventory_item/inv = inventory[item_data.name]
	inv.count++
	update_inventory_status()
	update_held_item_count()
	return 1

/mob/trainer/proc/update_held_item_count()
	held_items = 0
	for(var/thing in inventory)
		var/data/inventory_item/I = inventory[thing]
		held_items += I.count

/mob/trainer/remove_item(var/data/inventory_item/item, var/amt=1)
	if(!istype(item))
		return
	item.count--
	if(item.count <= 0)
		var/data/inventory_item/I = inventory[item.item_template.name]
		inventory[item.item_template.name] = null
		inventory -= item.item_template.name
		qdel(I)
	update_held_item_count()
	return
