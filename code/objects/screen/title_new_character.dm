/obj/screen/title/panel
	name = ""
	icon = 'icons/screen/infopanel.dmi'
	icon_state = "base"
	screen_loc = "7,3"
	layer = SCREEN_EFFECTS_LAYER+0.3
	var/data/new_character_panel/master_panel

/obj/screen/title/panel/New(var/data/new_character_panel/_master)
	master_panel = _master
	var/matrix/M = matrix()
	M.Translate(-16,0)
	transform = M

/obj/screen/title/panel/arrow
	icon = 'icons/screen/title_buttons.dmi'
	icon_state = "arrow_left"
	var/slot_type

/obj/screen/title/panel/arrow/clicked()
	world << "[slot_type] [icon_state]"

/obj/screen/title/panel/arrow/New(var/data/new_character_panel/_master, var/_slot_type, var/_row)
	. = ..()
	screen_loc = "11,13-[_row]"
	slot_type = _slot_type

/obj/screen/title/panel/arrow/right
	icon_state = "arrow_right"

/obj/screen/title/panel/arrow/right/New(var/data/new_character_panel/_master, var/_slot_type, var/_row)
	. = ..()
	screen_loc = "15,13-[_row]"

/obj/screen/title/panel/exit
	icon = 'icons/screen/title_buttons.dmi'
	icon_state = "cross"
	screen_loc = "15,14"

/obj/screen/title/panel/exit/clicked(var/client/clicker)
	master_panel.clear()
