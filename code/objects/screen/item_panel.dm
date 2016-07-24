/obj/screen/item_panel
	name = "Item Panel"
	var/data/inventory_item/held_item

/obj/screen/item_panel/clicked(var/client/clicker)

	if(!held_item)
		return

	var/mob/trainer/trainer = clicker.mob
	if(!istype(trainer))
		return

	trainer.notify("You have selected \the [held_item.item_template.name].")
	if(!held_item.item_template.can_use_battle)
		owner.notify("You can't use \the [held_item.item_template.name] outside of battle.")
		return

	owner.notify("Who do you wish to use this item on?")
	var/data/minion/chosen_target = owner.select_minion_from_list(trainer.minions)
	if(!chosen_target)
		return

	if(chosen_target)
		notify_nearby("<b>\The [trainer]</b> used \the <b>[held_item.item_template.name]</b> on \the [chosen_target.name]!")
		held_item.item_template.apply(chosen_target)
		trainer.remove_item(held_item,1)

	trainer.update_inventory_status()
