/mob/trainer/create_hud()

	if(!overworld_barrier)
		overworld_barrier = new /obj/screen/barrier()

	if(!screen_hud)
		screen_hud = list(new /obj/screen/sprint(src), overworld_barrier)

		for(var/i=1 to 6)
			var/obj/screen/minion_panel/MS = new (src)
			MS.screen_loc = "16,[15-i]"
			minion_status_panels += MS
			var/obj/screen/inventory_panel/I = new (src)
			I.screen_loc = "1,[15-i]"
			inventory_panels += I

		minion_toggle = new /obj/screen/minion_toggle(src)
		screen_hud += minion_toggle
		inventory_panels += new /obj/screen/inventory_panel_arrow(src)
		inventory_panels += new /obj/screen/inventory_panel_arrow/down(src)
		inventory_toggle = new /obj/screen/inventory_toggle(src)
		screen_hud += inventory_toggle

		notifications = new /obj/screen/notify(src)
		screen_hud += notifications.elements
	..()

/mob/trainer/proc/update_minion_status()
	for(var/i=1 to minion_status_panels.len)
		var/obj/screen/minion_panel/MS = minion_status_panels[i]
		MS.set_minion(minions.len >= i ? minions[i] : null)

/mob/proc/notify(var/message)
	src << message

/mob/trainer/notify(var/message)
	..()
	if(notifications)
		notifications.display(message)

/mob/trainer/proc/reset_ui()
	if(!client)
		return
	minion_toggle.reset()
	inventory_toggle.reset()
