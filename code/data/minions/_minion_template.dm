/data/minion_template
	var/name = "Minion"
	var/description = "A minion."
	var/icon_state = "minion"
	var/list/techs = list(
		/data/technique/combat
		)
	var/list/elemental_types = list(DAM_NEUTRAL)
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
	var/gem_colour = WHITE

/data/minion_template/proc/get_type_weakness(var/damtype)
	return 1

/data/minion_template/proc/get_type_strength(var/damtype)
	return 1

/data/minion_template/proc/get_same_type_attack_bonus(var/damtype)
	if(damtype in elemental_types)
		if(elemental_types.len == 1)
			return 2
		else
			return 1.5
	return 1
