/data/selected_minion
	var/data/minion/selection
	var/cancelled

/data/selected_minion/destroy()
	selection = null
	return ..()

/obj/screen/minion_select
	name = "Select Minion"
	var/data/minion/minion
	var/data/selected_minion/reporting_to

/obj/screen/minion_select/destroy()
	minion = null
	reporting_to = null
	return ..()

/obj/screen/minion_select/New(var/data/minion/_minion, var/data/selected_minion/_reporting)
	minion = _minion
	name = "Select [minion.name]"
	reporting_to = _reporting
	minion.status_bar.update()
	appearance = minion.status_bar

/obj/screen/minion_select/clicked(var/client/clicker)
	if(reporting_to && !reporting_to.selection && !reporting_to.cancelled)
		color = PALE_GREY
		reporting_to.selection = minion

/obj/screen/cancel_minion_select
	name = "Cancel"
	icon = 'icons/screen/selection.dmi'
	icon_state = "cancel"
	var/data/selected_minion/reporting_to

/obj/screen/cancel_minion_select/destroy()
	reporting_to = null
	return ..()

/obj/screen/cancel_minion_select/New(var/data/selected_minion/_reporting)
	reporting_to = _reporting

/obj/screen/cancel_minion_select/clicked()
	if(reporting_to && !reporting_to.selection && !reporting_to.cancelled)
		color = PALE_GREY
		reporting_to.cancelled = 1
