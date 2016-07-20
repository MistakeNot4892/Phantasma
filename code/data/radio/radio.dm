var/list/radio_list = list()
var/list/radio_frequencies = list("145.1","145.3","145.5","145.7","145.9")

/data/radio
	var/mob/trainer/owner
	var/is_on = 1
	var/freq

/data/radio/destroy()
	owner = null
	radio_list -= src
	return ..()

/data/radio/New(var/mob/trainer/_owner)
	owner = _owner
	radio_list += src
	freq = radio_frequencies[1]

/data/radio/proc/transmit(var/message)
	for(var/thing in radio_list)
		var/data/radio/other_radio = thing
		if(other_radio.is_on && other_radio.freq == freq && other_radio.owner && other_radio.owner.client)
			other_radio.owner.notify("\[[freq]\] <i>[message]</i>")
