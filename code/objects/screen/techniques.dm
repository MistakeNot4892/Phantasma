/obj/screen/technique
	name = "\improper Technique"
	icon = 'icons/screen/technique_menu.dmi'
	maptext_width = 112
	maptext_x = 8
	maptext_y = 9

	var/data/technique/tech
	var/data/minion/owning_minion

/obj/screen/technique/New(var/data/minion/_owning_minion, var/data/technique/_tech)
	tech = _tech
	owning_minion = _owning_minion
	update_tech()

/obj/screen/technique/proc/update_tech()
	if(!tech)
		invisibility = 100
		return
	invisibility = 0
	name = "[tech.name]"
	maptext = "<span style='font-family:courier; font-size:-3pt'><font color = '[PALE_BLUE]'>[tech.name] <b>[owning_minion.tech_uses[tech.name]]</b></font></span>"

/obj/screen/technique/destroy()
	tech = null
	owning_minion = null
	return ..()
