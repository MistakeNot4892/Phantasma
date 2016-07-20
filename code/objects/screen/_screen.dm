/obj/screen
	name = "screen element"
	icon = 'icons/screen/_screen.dmi'
	plane = OVERWORLD_UI_PLANE

	var/mob/owner

/obj/screen/New(var/_owner)
	owner = _owner

/obj/screen/proc/update_icon()
	return

/obj/screen/sprint
	name = "\improper Run"
	icon_state = "sprint_off"
	screen_loc = "20,7"

/obj/screen/sprint/update_icon()
	icon_state = "sprint_[(owner && owner.sprinting) ? "on" : "off"]"

/obj/screen/sprint/clicked(var/client/clicker)
	owner.sprinting = !owner.sprinting
	owner.update_icon()
	update_icon()
	clicker << "You are now <b>[owner.sprinting ? "running" : "walking"]</b>."

/obj/screen/menu
	name = "\improper Menu"
	icon_state = "menu_closed"
	screen_loc = "3,2"
	var/expanded
	var/list/menu_components = list()

/obj/screen/menu/clicked(var/client/clicker)
	expanded = !expanded
	if(expanded)
		icon_state = "menu_open"
		clicker.screen += menu_components
	else
		icon_state = "menu_closed"
		clicker.screen -= menu_components

/obj/screen/menu/New()
	..()
	menu_components += new /obj/screen/inventory(owner)
	menu_components += new /obj/screen/minions(owner)
	menu_components += new /obj/screen/options(owner)
	menu_components += new /obj/screen/map(owner)

/obj/screen/inventory
	name = "\improper Bag"
	icon_state = "inventory"
	screen_loc = "3,4"

/obj/screen/minions
	name = "\improper Minions"
	icon_state = "minions"
	screen_loc = "3,5"

/obj/screen/options
	name = "\improper Options"
	icon_state = "options"
	screen_loc = "3,6"

/obj/screen/map
	name = "\improper World Map"
	icon_state = "map"
	screen_loc = "3,7"
