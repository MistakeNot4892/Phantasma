/mob/trainer
	var/data/radio/radio

/mob/trainer/New()
	. = ..()
	radio = new /data/radio(src)

/mob/trainer/verb/verb_toggle_radio()
	set name="Toggle Radio"
	set category="Communication"
	set desc="Turn your radio on or off."
	toggle_radio()

/mob/trainer/verb/verb_change_radio_frequency()
	set name="Change Radio Frequency"
	set category="Communication"
	set desc="Change the frequency of your radio."
	change_radio_frequency()

/mob/trainer/proc/toggle_radio()
	radio.is_on = !radio.is_on
	src.notify("You switch your radio [radio.is_on ? "on" : "off"].")

/mob/trainer/proc/change_radio_frequency()
	var/new_freq = input("Select a new frequency.") as null|anything in radio_frequencies
	if(!new_freq)
		return
	radio.freq = new_freq
	src.notify("You set your radio frequency to [radio.freq].")

/mob/trainer/verb/use_radio(var/message as text)

	set name="Radio"
	set category="Communication"
	set desc="Speak your mind to everyone!"

	if(!message)
		message = input("What would you like to say?") as text|null

	if(!message)
		return

	if(!radio.is_on)
		src.notify("Your radio is turned off.")
		return

	var/list/result = format_string_for_speech(src, message)
	radio.transmit(result[1])
	show_overhead_icon(result[2])
