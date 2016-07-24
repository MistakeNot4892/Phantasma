/data/selected
	var/selection
	var/cancelled

/data/selected/destroy()
	selection = null
	return ..()

/obj/screen/select
	var/data/selected/reporting_to
	var/contains

/obj/screen/select/destroy()
	reporting_to = null
	contains = null
	return ..()

/obj/screen/select/New(var/data/selected/_reporting, var/_contains, var/emulate_appearance)
	contains = _contains
	reporting_to = _reporting
	appearance = emulate_appearance

/obj/screen/select/clicked(var/client/clicker)
	if(reporting_to && !reporting_to.selection && !reporting_to.cancelled)
		color = PALE_GREY
		reporting_to.selection = contains

/obj/screen/cancel_select
	name = "Cancel"
	icon = 'icons/screen/selection.dmi'
	icon_state = "cancel"
	var/data/selected/reporting_to

/obj/screen/cancel_select/destroy()
	reporting_to = null
	return ..()

/obj/screen/cancel_select/New(var/data/selected/_reporting)
	reporting_to = _reporting

/obj/screen/cancel_select/clicked()
	if(reporting_to && !reporting_to.selection && !reporting_to.cancelled)
		color = PALE_GREY
		reporting_to.cancelled = 1
