/mob/trainer/do_say(var/message)
	var/list/result = format_string_for_speech(src, message)
	next_speech = world.time + 15
	notify_nearby(result[1])
	show_overhead_icon(result[2])

/mob/trainer/do_emote(var/message)
	next_speech = world.time + 25
	message = format_and_capitalize("<b>\The [src]</b> [sanitize_text(message)]")
	notify_nearby(copytext(message,1,120))
