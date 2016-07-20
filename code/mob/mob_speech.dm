var/list/overhead_icon_states = icon_states('icons/overworld/dialogue_overhead_icons.dmi')

/mob/verb/emote(var/message as text)
	if(!message)
		message = input("What would you like to do?") as text|null

	message = format_and_capitalize("<b>\The [src]</b> [sanitize_text(message)]")
	notify_nearby(message)

/proc/format_string_for_speech(var/mob/speaker, var/message)

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

	return list("<b>\The [speaker]</b> [speak_verb], \"[message]\"", overhead_icon)

/mob/verb/say(var/message as text)

	set name="Say"
	set category="Communication"
	set desc="Speak your mind!"

	if(!message)
		message = input("What would you like to say?") as text|null

	if(!message)
		return

	var/list/result = format_string_for_speech(src, message)

	notify_nearby(result[1])
	show_overhead_icon(result[2])

/mob/proc/show_overhead_icon(var/message_icon)
	if(!(message_icon in overhead_icon_states))
		return
	new /obj/effect/speech(get_turf(src), message_icon, 10)
