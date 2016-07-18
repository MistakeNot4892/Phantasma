var/list/overhead_icon_states = icon_states('icons/overworld/dialogue_overhead_icons.dmi')

/mob/verb/emote(var/message as text)
	if(!message)
		message = input("What would you like to do?") as text|null

	message = format_and_capitalize("<b>\The [src]</b> [sanitize_text(message)]")
	visible_message(message)

/mob/verb/say(var/message as text)

	if(!message)
		message = input("What would you like to say?") as text|null

	if(!message)
		return

	// Do some basic formatting.
	message = format_and_capitalize(sanitize_text(message))

	var/speak_verb = "says"
	var/overhead_icon = "speech"
	var/ending = copytext(message, length(message))

	if(ending == "!")
		speak_verb = "exclaims"
		overhead_icon = "shout"
	else if(ending == "?")
		speak_verb = "asks"
		overhead_icon = "ask"

	show_overhead_icon(overhead_icon)
	visible_message("<b>\The [src]</b> [speak_verb], \"[message]\"")

/mob/proc/visible_message(var/message)
	for(var/mob/M in range(src,world.view))
		M << message

/mob/proc/show_overhead_icon(var/message_icon)
	if(!(message_icon in overhead_icon_states))
		return
	new /obj/effect/speech(get_turf(src), message_icon, 5)
