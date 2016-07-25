/data/new_character_panel
	var/list/elements = list()
	var/client/client
	var/mob/trainer/mannequin/mannequin
	var/obj/screen/title/panel/panel
	var/list/text_objects = list()

/data/new_character_panel/New(var/client/_client)
	panel = new /obj/screen/title/panel(src)
	elements += panel
	elements += new /obj/screen/title/panel/exit(src)
	elements += new /obj/screen/title/panel/confirm(src)
	var/i = 0
	for(var/slot in ALL_TRAINER_ICON_STRINGS)
		text_objects[slot] = new /obj/screen/text(slot, _x=130, _y=330-(i*32), _colour=DARK_BROWN)
		elements += new /obj/screen/title/panel/arrow(src, slot, i)
		elements += new /obj/screen/title/panel/arrow/right(src, slot, i)
		i++

	mannequin = new()
	reconnected(_client)

/data/new_character_panel/proc/reconnected(var/client/_client)
	if(_client && client != _client)
		if(client)
			client.screen -= elements
		client = _client
	update()

/data/new_character_panel/proc/update()

	mannequin.icon_strings = list(
		TRAINER_ICON_BODY = "female",
		TRAINER_ICON_CLOTHES = "elea",
		TRAINER_ICON_HAIR = "long_brown",
		TRAINER_ICON_EYES = "brown"
		)
	mannequin.update_icon()

	var/list/images_to_add = list()
	var/image/I = image(null)
	I.appearance = mannequin
	I.layer = SCREEN_EFFECTS_LAYER+0.4
	I.plane = SCREEN_PLANE
	I.pixel_x = 14
	I.pixel_y = 185
	images_to_add += I

	I = mannequin.get_battle_image(frontal=1)
	I.layer = SCREEN_EFFECTS_LAYER+0.4
	I.plane = SCREEN_PLANE
	I.pixel_x = -42
	I.pixel_y = 160
	images_to_add += I

	for(var/slot in ALL_TRAINER_ICON_STRINGS)
		I = image(null)
		var/obj/screen/text/T = text_objects[slot]
		T.set_text(mannequin.icon_strings[slot])
		I.appearance = T
		I.layer = SCREEN_EFFECTS_LAYER+0.5
		I.plane = SCREEN_PLANE
		images_to_add += I

	panel.overlays.Cut()
	panel.overlays += images_to_add

	if(client)
		client.screen |= elements

/data/new_character_panel/proc/clear()
	if(client)
		client.screen -= elements

/data/new_character_panel/destroy()
	if(client)
		client.screen -= elements
		client = null
	for(var/thing in elements)
		qdel(thing)
	elements.Cut()
	for(var/slot in text_objects)
		qdel(text_objects[slot])
	text_objects.Cut()
	return ..()

/data/new_character_panel/proc/finalize()
	clear()
	var/mob/trainer/trainer = new()
	trainer.name = mannequin.name
	trainer.icon_strings = mannequin.icon_strings
	trainer.update_icon()
	var/mob/new_player/NP = client.mob
	NP.do_join(trainer)
	qdel(src)

/mob/new_player
	var/data/new_character_panel/new_character_panel

/mob/new_player/proc/create_new_character()
	if(new_character_panel)
		new_character_panel.reconnected(client)
	if(!new_character_panel)
		new_character_panel = new(client)
