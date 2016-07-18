/minion_template
	var/name = "Minion"
	var/icon_state = "minion"
	var/list/techs = list(
		/technique
		)

	var/list/data = list(
		MD_MHP =   100,
		MD_ATK =   10,
		MD_DEF =   10,
		MD_SPATK = 10,
		MD_SPDEF = 10,
		MD_SPEED = 10,
		MD_FLEE = 5,
		MD_SPEED_VAR_MIN = 1,
		MD_SPEED_VAR_MAX = 3
		)

/mob/minion
	name = "minion"
	desc = "A minion."
	icon = 'icons/minions/overmap.dmi'
	density = 0
	layer = MOB_LAYER-0.1

	var/wild
	var/minion/minion_data
	var/turf/return_loc

/mob/minion/wild
	wild = 1
	density = 1
	layer = MOB_LAYER

/mob/minion/clicked(var/client/clicker)
	clicker << "<b>[minion_data.owner ? "\The [minion_data.owner]'s" : "A wild"] [name].</b>"
	clicker << "<b>Level:</b> [minion_data.data[MD_LVL]] ([minion_data.data[MD_EXP]]), [minion_data.data[MD_CHP]]/[minion_data.data[MD_MHP]]HP	"
	clicker << "ATK: [minion_data.data[MD_ATK]] DEF: [minion_data.data[MD_DEF]] SPD: [minion_data.data[MD_SPEED]]"
	clicker << "SPATK: [minion_data.data[MD_SPATK]] SPDEF: [minion_data.data[MD_SPDEF]]"
	clicker << "<br><b>Techniques:</b>"
	for(var/technique/T in minion_data.techs)
		clicker << "[T.name] \[[minion_data.tech_uses[T.name]]/[T.max_uses]\]"

/mob/minion/get_movement_delay()
	return 0

/mob/minion/New(var/newloc, var/minion/_data)
	..(newloc)
	change_to_minion(_data)

/mob/minion/proc/change_to_minion(var/minion/_data)
	set waitfor=0
	set background=1
	minion_data = _data
	name = minion_data.name
	animate(src, alpha=0, time = 3)
	sleep(3)
	icon_state = minion_data.template.icon_state
	animate(src, alpha=255, time = 3)

/mob/minion/end_battle()
	if(wild)
		density = 0
		spawn(10)
			animate(src,alpha=0,time=5)
		sleep(15)
		qdel(src)

/mob/minion/get_minion()
	return minion_data

/mob/minion/restore()
	minion_data.restore()
