/mob
	var/list/screen_hud
	var/obj/screen/notify_scroll/text/text_show

/mob/proc/create_hud()
	if(!screen_hud)
		screen_hud = list()
	if(!text_show)
		text_show = new /obj/screen/notify_scroll/text(src)
		screen_hud += text_show
	return

/mob/verb/text_window_closed()
	set name="Close Text Window"
	set category="Communication"
	set desc="Close the text window popup."
	set hidden = 1
	text_show.icon_state = "text"

var/motd = "Please enjoy your stay!"
/client/New()
	. = ..()
	src << "<font color = '[BROWN_DARK]' align = 'center'><b>Welcome to Phantasma!</b><br>[motd]<hr><br></font>"
