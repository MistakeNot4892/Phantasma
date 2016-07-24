/data/inventory_item
	var/count = 0
	var/item_template_path
	var/tmp/mob/trainer/owner
	var/tmp/data/item/item_template
	var/tmp/obj/screen/item_status/item_status

/data/inventory_item/New(var/_item_template_path, var/mob/trainer/_owner)
	. = ..()
	item_status = new()
	if(_item_template_path && _owner)
		initialize(_item_template_path, _owner)

/data/inventory_item/initialize(var/_item_template_path, var/mob/trainer/_owner)
	owner = _owner
	item_template_path = _item_template_path
	item_template = get_unique_data_by_path(item_template_path)
	item_status.update(src)

/data/inventory_item/destroy()
	owner = null
	item_template = null
	if(item_status)
		qdel(item_status)
		item_status = null
	return ..()
