/data/inventory_item
	var/count = 0
	var/mob/trainer/owner
	var/data/item/template

/data/inventory_item/New(var/mob/trainer/_owner, var/data/item/_item)
	owner = _owner
	template = _item

/data/inventory_item/destroy()
	owner = null
	template = null
	return ..()
