/mob/trainer/create_hud()

	if(!overworld_barrier)
		overworld_barrier = new /obj/screen/barrier()

	if(!screen_hud)
		screen_hud = list(new /obj/screen/sprint(src), overworld_barrier)
		for(var/i=1 to 6)
			var/obj/screen/minion_panel_button/MS = new (src)
			MS.screen_loc = "16,[15-i]"
			minion_status += MS
		notifications = new /obj/screen/notify(src)
		screen_hud += notifications.elements
		minion_toggle = new /obj/screen/minion_toggle(src)
		screen_hud += minion_toggle
	..()

/mob/trainer/proc/update_minion_status()
	for(var/i=1 to minion_status.len)
		var/obj/screen/minion_panel_button/MS = minion_status[i]
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
