/client/proc/save_trainer(var/mob/trainer/trainer, var/save_loc)

	if(!istype(trainer))
		return

	src.mob.notify("Saving your game...")

	var/savefile = new/savefile("saves/[ckey]")
	savefile["name"]      << trainer.name
	savefile["body"]      << trainer.icon_body
	savefile["eyes"]      << trainer.icon_eyes
	savefile["clothes"]   << trainer.icon_clothes
	savefile["hair"]      << trainer.icon_hair
	savefile["neard"]     << trainer.icon_beard
	savefile["hat"]       << trainer.icon_hat
	savefile["minions"]   << trainer.minions
	savefile["inventory"] << trainer.inventory

	if(save_loc)
		savefile["save_x"] << trainer.x
		savefile["save_y"] << trainer.y
		savefile["save_z"] << trainer.z

	src.mob.notify("Save complete!")

/client/proc/load_trainer(var/mob/trainer/trainer)

	if(!istype(trainer))
		trainer = new()

	if(trainer.minions.len)
		for(var/thing in trainer.minions)
			qdel(thing)
		trainer.minions.Cut()
	if(trainer.inventory.len)
		for(var/thing in trainer.inventory)
			qdel(thing)
		trainer.inventory.Cut()

	var/loadfile = new/savefile("saves/[ckey]")
	loadfile["name"]      >> trainer.name
	loadfile["body"]      >> trainer.icon_body
	loadfile["eyes"]      >> trainer.icon_eyes
	loadfile["clothes"]   >> trainer.icon_clothes
	loadfile["hair"]      >> trainer.icon_hair
	loadfile["neard"]     >> trainer.icon_beard
	loadfile["hat"]       >> trainer.icon_hat
	loadfile["minions"]   >> trainer.minions
	loadfile["inventory"] >> trainer.inventory
	loadfile["save_x"]    >> trainer.last_save_x
	loadfile["save_y"]    >> trainer.last_save_y
	loadfile["save_z"]    >> trainer.last_save_z

	for(var/data/minion/M in trainer.minions)
		M.initialize(M.template_path, trainer)

	for(var/item in trainer.inventory)
		var/data/inventory_item/I = trainer.inventory[item]
		I.initialize(I.item_template_path, trainer)

	trainer.reset_ui()
	trainer.update_icon()
	trainer.update_following_minion()
	return trainer